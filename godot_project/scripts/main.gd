class_name MainGame
extends Node2D

const BLOCK_SCENE = preload("res://scenes/block.tscn")
const SPIKE_SCENE = preload("res://scenes/spike.tscn")
const DOOR_SCENE = preload("res://scenes/door.tscn")
const PLAYER_SCENE = preload("res://scenes/player.tscn")
const FLOATING_TEXT_SCENE = preload("res://scenes/floating_text.tscn")

@onready var hud: HUD = $HUD
@onready var camera: Camera2D = $Camera2D
@onready var level_container: Node2D = $LevelContainer
@onready var background_rect: ColorRect = $BackgroundRect

var levels_data: Array = []
var current_level_index: int = 0
var deaths_count: int = 0
var is_transitioning: bool = false

var player: Player
var current_door: ExitDoor
var current_blocks: Array[LevelBlock] = []
var current_spikes: Array[Spike] = []
var troll_manager: TrollManager = TrollManager.new()

var just_jumped_this_frame: bool = false
var camera_shake_amount: float = 0.0

func _ready() -> void:
	load_all_levels()

	if hud:
		hud.restart_requested.connect(restart_level)
		hud.level_selected.connect(func(idx): load_level(idx))

	load_level(0)

func load_all_levels() -> void:
	var path: String = "res://data/levels.json"
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var text = file.get_as_text()
		var json = JSON.new()
		var parse_err = json.parse(text)
		if parse_err == OK and json.data is Array:
			levels_data = json.data
		else:
			print("JSON Parse error:", parse_err)
	else:
		print("levels.json not found at:", path)

func load_level(index: int) -> void:
	if levels_data.is_empty():
		return

	current_level_index = clamp(index, 0, levels_data.size() - 1)
	var lvl_data: Dictionary = levels_data[current_level_index]

	# Clear previous level nodes
	for child in level_container.get_children():
		child.queue_free()
	current_blocks.clear()
	current_spikes.clear()
	current_door = null
	is_transitioning = false

	# Theme Background
	var theme_data: Dictionary = lvl_data.get("theme", {})
	var sky_top_hex: String = str(theme_data.get("skyTop", "#0d091a"))
	background_rect.color = Color.from_string(sky_top_hex, Color(0.05, 0.03, 0.1))

	var block_base_col = Color.from_string(str(theme_data.get("blockBase", "#1f1035")), Color(0.12, 0.06, 0.21))
	var block_top_col = Color.from_string(str(theme_data.get("blockTop", "#c084fc")), Color(0.75, 0.52, 0.98))
	var spike_col = Color.from_string(str(theme_data.get("spikeColor", "#f43f5e")), Color(0.95, 0.25, 0.35))

	# 1. Spawn Blocks
	var blocks_list = lvl_data.get("blocks", [])
	for b_info in blocks_list:
		var b_node: LevelBlock = BLOCK_SCENE.instantiate() as LevelBlock
		b_node.block_id = str(b_info.get("id", ""))
		b_node.block_type = str(b_info.get("type", "solid"))
		b_node.block_size = Vector2(float(b_info.get("w", 80)), float(b_info.get("h", 40)))
		b_node.position = Vector2(float(b_info.get("x", 0)), float(b_info.get("y", 0)))
		b_node.color_base = block_base_col
		b_node.color_top = block_top_col
		level_container.add_child(b_node)
		current_blocks.append(b_node)

	# 2. Spawn Spikes
	var spikes_list = lvl_data.get("spikes", [])
	for s_info in spikes_list:
		var s_node: Spike = SPIKE_SCENE.instantiate() as Spike
		s_node.spike_id = str(s_info.get("id", ""))
		s_node.direction = str(s_info.get("direction", "up"))
		s_node.spike_size = Vector2(float(s_info.get("w", 24)), float(s_info.get("h", 24)))
		s_node.position = Vector2(float(s_info.get("x", 0)), float(s_info.get("y", 0)))
		s_node.jumps_with_player = bool(s_info.get("jumpsWithPlayer", false))
		s_node.is_hidden = bool(s_info.get("hidden", false))
		s_node.spike_color = spike_col
		level_container.add_child(s_node)
		current_spikes.append(s_node)

	# 3. Spawn Door
	var door_info = lvl_data.get("door", {})
	current_door = DOOR_SCENE.instantiate() as ExitDoor
	current_door.door_size = Vector2(float(door_info.get("w", 32)), float(door_info.get("h", 44)))
	current_door.position = Vector2(float(door_info.get("x", 700)), float(door_info.get("y", 336)))
	current_door.entered.connect(_on_level_cleared)
	level_container.add_child(current_door)

	# 4. Spawn Player
	var start_pos_info = lvl_data.get("playerStart", { "x": 80, "y": 350 })
	var start_pos = Vector2(float(start_pos_info.get("x", 80)), float(start_pos_info.get("y", 350)))
	var grav_dir: int = int(lvl_data.get("gravityDirection", 1))

	if player == null:
		player = PLAYER_SCENE.instantiate() as Player
		add_child(player)
		player.died.connect(_on_player_died)
		player.jumped.connect(func(): just_jumped_this_frame = true)

	player.respawn(start_pos, grav_dir)
	player.is_on_ice = bool(lvl_data.get("icePhysics", false))

	# 5. Initialize Troll Manager
	var triggers = lvl_data.get("triggers", [])
	troll_manager.init(player, current_door, current_blocks, current_spikes, triggers, self)

	# 6. Update HUD
	var title = str(lvl_data.get("title", "Level " + str(current_level_index + 1)))
	var subtitle = str(lvl_data.get("subtitle", ""))
	var hint = str(lvl_data.get("hint", lvl_data.get("initialHint", "")))
	hud.update_hud(title, subtitle, deaths_count, hint)

func restart_level() -> void:
	if levels_data.is_empty():
		return

	var lvl_data: Dictionary = levels_data[current_level_index]
	var start_pos_info = lvl_data.get("playerStart", { "x": 80, "y": 350 })
	var start_pos = Vector2(float(start_pos_info.get("x", 80)), float(start_pos_info.get("y", 350)))
	var grav_dir: int = int(lvl_data.get("gravityDirection", 1))

	# Reset all entities
	if player:
		player.respawn(start_pos, grav_dir)
		player.is_on_ice = bool(lvl_data.get("icePhysics", false))

	if current_door:
		current_door.reset_door()

	for b in current_blocks:
		b.reset_block()

	for s in current_spikes:
		s.reset_spike()

	troll_manager.reset()
	is_transitioning = false

func _on_player_died() -> void:
	deaths_count += 1
	shake_camera(14.0)
	var lvl_data: Dictionary = levels_data[current_level_index]
	var title = str(lvl_data.get("title", ""))
	var subtitle = str(lvl_data.get("subtitle", ""))
	var hint = str(lvl_data.get("hint", ""))
	hud.update_hud(title, subtitle, deaths_count, hint)

	# Auto-restart after snappy delay (0.32s)
	await get_tree().create_timer(0.32).timeout
	restart_level()

func _on_level_cleared() -> void:
	if is_transitioning:
		return
	is_transitioning = true
	spawn_floating_text("LEVEL CLEAR! 🎉", current_door.position + Vector2(0, -30), Color(0.2, 0.95, 0.4))
	await get_tree().create_timer(0.65).timeout

	if current_level_index + 1 < levels_data.size():
		load_level(current_level_index + 1)
	else:
		spawn_floating_text("YOU BEAT THE GAME! 🏆", Vector2(400, 200), Color(1, 0.8, 0.2))

func shake_camera(intensity: float) -> void:
	camera_shake_amount = max(camera_shake_amount, intensity)

func spawn_floating_text(text: String, pos: Vector2, color: Color) -> void:
	var ft = FLOATING_TEXT_SCENE.instantiate()
	ft.position = pos
	ft.setup(text, color)
	add_child(ft)

func _physics_process(delta: float) -> void:
	# Quick restart hotkey
	if Input.is_action_just_pressed("restart") or Input.is_key_pressed(KEY_R):
		restart_level()

	# Process troll manager
	troll_manager.check_triggers(just_jumped_this_frame)
	just_jumped_this_frame = false

	# Camera Shake decay
	if camera_shake_amount > 0.0:
		camera.offset = Vector2(
			randf_range(-camera_shake_amount, camera_shake_amount),
			randf_range(-camera_shake_amount, camera_shake_amount)
		)
		camera_shake_amount = move_toward(camera_shake_amount, 0.0, delta * 30.0)
	else:
		camera.offset = Vector2.ZERO

	# Check off-screen fall death
	if player and not player.is_dead:
		if player.position.y > 520.0 or player.position.y < -150.0:
			player.kill("Fell into the void!")
