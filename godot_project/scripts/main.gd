extends Node2D

const BLOCK_SCENE = preload("res://scenes/block.tscn")
const SPIKE_SCENE = preload("res://scenes/spike.tscn")
const DOOR_SCENE = preload("res://scenes/door.tscn")
const PLAYER_SCENE = preload("res://scenes/player.tscn")
const FLOATING_TEXT_SCENE = preload("res://scenes/floating_text.tscn")
const TrollManagerClass = preload("res://scripts/troll_manager.gd")
const INTRO_SCENE = preload("res://scenes/intro.tscn")
const DARKNESS_SHADER = preload("res://shaders/darkness.gdshader")

@onready var hud: CanvasLayer = get_node_or_null("HUD")
@onready var camera: Camera2D = get_node_or_null("Camera2D")
@onready var level_container: Node2D = get_node_or_null("LevelContainer")
@onready var background_rect: ColorRect = get_node_or_null("BackgroundRect")
@onready var intro_layer: CanvasLayer = get_node_or_null("IntroLayer")
@onready var intro: Control = get_node_or_null("IntroLayer/Intro")

var levels_data: Array = []
var current_level_index: int = 0
var deaths_count: int = 0
var is_transitioning: bool = false

var player: CharacterBody2D
var current_door: Area2D
var current_blocks: Array = []
var current_spikes: Array = []
var troll_manager = TrollManagerClass.new()

var just_jumped_this_frame: bool = false
var darkness_rect: ColorRect
var darkness_material: ShaderMaterial
var is_dark_room: bool = false
var death_timer_id: int = 0
var transition_id: int = 0

var save_data: Dictionary = {
	"entrance_cleared": false,
	"max_unlocked_level": 0,
	"deaths_count": 0
}

func load_save_data() -> void:
	var path = "user://save_data.json"
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var text = file.get_as_text()
		var json = JSON.new()
		if json.parse(text) == OK and json.data is Dictionary:
			save_data = json.data
			deaths_count = int(save_data.get("deaths_count", 0))

func save_save_data() -> void:
	var path = "user://save_data.json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		save_data["deaths_count"] = deaths_count
		file.store_string(JSON.stringify(save_data, "\t"))

func is_level_unlocked(lvl_idx: int) -> bool:
	if lvl_idx == 0:
		return true # Entrance test is always accessible
	var entrance_cleared: bool = bool(save_data.get("entrance_cleared", false))
	if not entrance_cleared:
		return false
	var max_unlocked: int = int(save_data.get("max_unlocked_level", 0))
	return lvl_idx <= max_unlocked

func sync_progression_ui() -> void:
	var entrance_cleared: bool = bool(save_data.get("entrance_cleared", false))
	var max_unlocked: int = int(save_data.get("max_unlocked_level", 0))
	if intro and intro.has_method("update_intro_state"):
		intro.update_intro_state(entrance_cleared, max_unlocked)
	if hud and hud.has_method("populate_level_grid"):
		hud.populate_level_grid(max(1, levels_data.size() - 1), max_unlocked, entrance_cleared)

func _ready() -> void:
	if intro_layer == null:
		intro_layer = CanvasLayer.new()
		intro_layer.name = "IntroLayer"
		intro_layer.layer = 5
		add_child(intro_layer)
		intro = INTRO_SCENE.instantiate()
		intro.name = "Intro"
		intro_layer.add_child(intro)

	darkness_material = ShaderMaterial.new()
	darkness_material.shader = DARKNESS_SHADER
	darkness_rect = ColorRect.new()
	darkness_rect.name = "DarknessOverlay"
	darkness_rect.size = Vector2(800, 450)
	darkness_rect.material = darkness_material
	darkness_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	darkness_rect.z_index = 10
	darkness_rect.visible = false
	add_child(darkness_rect)

	load_all_levels()
	load_save_data()
	sync_progression_ui()

	if hud:
		hud.connect("restart_requested", Callable(self, "restart_level"))
		hud.connect("level_selected", Callable(self, "load_level"))
		hud.connect("menu_requested", Callable(self, "show_intro"))

	if intro:
		intro.connect("play_pressed", Callable(self, "_on_intro_play"))
		intro.connect("level_select_pressed", Callable(self, "_on_intro_level_select"))

	var target_lvl: int = 0
	var skip_intro: bool = false
	var args = OS.get_cmdline_args()
	for i in range(args.size()):
		if args[i] == "--level" and i + 1 < args.size():
			target_lvl = clampi(int(args[i + 1]), 0, max(0, levels_data.size() - 1))
			skip_intro = true
		elif args[i].begins_with("--level="):
			target_lvl = clampi(int(args[i].substr(8)), 0, max(0, levels_data.size() - 1))
			skip_intro = true

	if not skip_intro:
		if bool(save_data.get("entrance_cleared", false)):
			target_lvl = clampi(int(save_data.get("max_unlocked_level", 1)), 1, max(0, levels_data.size() - 1))
		else:
			target_lvl = 0

	load_level(target_lvl)
	if skip_intro:
		_on_intro_play()
	else:
		show_intro()

func show_intro() -> void:
	death_timer_id += 1
	transition_id += 1
	is_transitioning = false
	sync_progression_ui()
	if darkness_rect:
		darkness_rect.visible = false
	if intro_layer:
		intro_layer.visible = true
	if intro:
		if intro.has_method("show_intro_screen"):
			intro.show_intro_screen()
		else:
			intro.visible = true
			intro.set_process(true)
	if hud:
		hud.visible = false
	if player:
		player.visible = false
		player.set_physics_process(false)

func _on_intro_play() -> void:
	if intro_layer:
		intro_layer.visible = false
	if intro:
		if intro.has_method("hide_intro"):
			intro.hide_intro()
		else:
			intro.visible = false
			intro.set_process(false)
	if hud:
		hud.visible = true
	if player:
		player.visible = true
		player.set_physics_process(true)
		restart_level()
	if darkness_rect:
		darkness_rect.visible = is_dark_room

func _on_intro_level_select() -> void:
	if intro_layer:
		intro_layer.visible = false
	if intro:
		if intro.has_method("hide_intro"):
			intro.hide_intro()
		else:
			intro.visible = false
			intro.set_process(false)
	if hud:
		hud.visible = true
	if player:
		player.visible = true
		player.set_physics_process(true)
	if darkness_rect:
		darkness_rect.visible = is_dark_room
	if hud.has_node("LevelSelectModal"):
		hud.get_node("LevelSelectModal").visible = true

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

	var target_idx = clamp(index, 0, levels_data.size() - 1)
	if not is_level_unlocked(target_idx):
		AudioManager.play_trap()
		var msg = "🔒 LOCKED! Clear the Entrance Test first! 🎓" if not bool(save_data.get("entrance_cleared", false)) else ("🔒 LOCKED! Clear Level %d first!" % (target_idx - 1))
		spawn_floating_text(msg, Vector2(400, 200), Color(1.0, 0.35, 0.35))
		return

	death_timer_id += 1
	transition_id += 1

	if intro_layer:
		intro_layer.visible = false
	if intro:
		if intro.has_method("hide_intro"):
			intro.hide_intro()
		else:
			intro.visible = false
			intro.set_process(false)
	if hud:
		hud.visible = true
	if player:
		player.visible = true
		player.set_physics_process(true)

	current_level_index = target_idx
	var lvl_data: Dictionary = levels_data[current_level_index]

	is_dark_room = bool(lvl_data.get("darkRoom", false))
	if darkness_rect:
		darkness_rect.visible = is_dark_room

	# Clear previous level nodes cleanly from physics tree immediately
	for child in level_container.get_children():
		level_container.remove_child(child)
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
		var b_node = BLOCK_SCENE.instantiate()
		b_node.set("block_id", str(b_info.get("id", "")))
		b_node.set("block_type", str(b_info.get("type", "solid")))
		b_node.set("block_size", Vector2(float(b_info.get("w", 80)), float(b_info.get("h", 40))))
		b_node.position = Vector2(float(b_info.get("x", 0)), float(b_info.get("y", 0)))
		b_node.set("color_base", block_base_col)
		b_node.set("color_top", block_top_col)
		level_container.add_child(b_node)
		current_blocks.append(b_node)

	# 2. Spawn Spikes
	var spikes_list = lvl_data.get("spikes", [])
	for s_info in spikes_list:
		var s_node = SPIKE_SCENE.instantiate()
		s_node.set("spike_id", str(s_info.get("id", "")))
		s_node.set("direction", str(s_info.get("direction", "up")))
		s_node.set("spike_size", Vector2(float(s_info.get("w", 24)), float(s_info.get("h", 24))))
		s_node.position = Vector2(float(s_info.get("x", 0)), float(s_info.get("y", 0)))
		s_node.set("jumps_with_player", bool(s_info.get("jumpsWithPlayer", false)))
		s_node.set("is_hidden", bool(s_info.get("hidden", false)))
		s_node.set("spike_color", spike_col)
		level_container.add_child(s_node)
		current_spikes.append(s_node)

	# 3. Spawn Door
	var door_info = lvl_data.get("door", {})
	current_door = DOOR_SCENE.instantiate()
	current_door.set("door_size", Vector2(float(door_info.get("w", 32)), float(door_info.get("h", 44))))
	current_door.position = Vector2(float(door_info.get("x", 700)), float(door_info.get("y", 336)))
	current_door.connect("entered", Callable(self, "_on_level_cleared"))
	level_container.add_child(current_door)

	# 4. Spawn Player
	var start_pos_info = lvl_data.get("playerStart", { "x": 80, "y": 350 })
	var start_pos = Vector2(float(start_pos_info.get("x", 80)), float(start_pos_info.get("y", 350)))
	var grav_dir: int = int(lvl_data.get("gravityDirection", 1))

	var is_ice: bool = bool(lvl_data.get("icePhysics", false))
	if player == null:
		player = PLAYER_SCENE.instantiate()
		add_child(player)
		player.connect("died", Callable(self, "_on_player_died"))
		player.connect("jumped", Callable(self, "_on_player_jumped"))

	player.set_physics_process(true)
	player.call("respawn", start_pos, grav_dir, is_ice)

	# 5. Initialize Troll Manager
	var triggers = lvl_data.get("triggers", [])
	troll_manager.init(player, current_door, current_blocks, current_spikes, triggers, self)

	# 6. Update HUD
	var title = str(lvl_data.get("title", "Level " + str(current_level_index + 1)))
	var subtitle = str(lvl_data.get("subtitle", ""))
	var hint = str(lvl_data.get("hint", lvl_data.get("initialHint", "")))
	if hud and hud.has_method("update_hud"):
		hud.update_hud(title, subtitle, deaths_count, hint)

func _on_player_jumped() -> void:
	just_jumped_this_frame = true
	for s in current_spikes:
		if bool(s.get("jumps_with_player")) and s.has_method("jump"):
			s.jump()

func restart_level() -> void:
	if levels_data.is_empty():
		return
	if is_transitioning:
		return

	death_timer_id += 1

	var lvl_data: Dictionary = levels_data[current_level_index]
	var start_pos_info = lvl_data.get("playerStart", { "x": 80, "y": 350 })
	var start_pos = Vector2(float(start_pos_info.get("x", 80)), float(start_pos_info.get("y", 350)))
	var grav_dir: int = int(lvl_data.get("gravityDirection", 1))
	var is_ice: bool = bool(lvl_data.get("icePhysics", false))

	if player:
		player.set_physics_process(true)
		player.call("respawn", start_pos, grav_dir, is_ice)

	if current_door:
		current_door.call("reset_door")

	for b in current_blocks:
		b.call("reset_block")

	for s in current_spikes:
		s.call("reset_spike")

	if darkness_rect:
		darkness_rect.visible = is_dark_room

	troll_manager.reset()
	is_transitioning = false

func _on_player_died() -> void:
	deaths_count += 1
	var lvl_data: Dictionary = levels_data[current_level_index]
	var title = str(lvl_data.get("title", ""))
	var subtitle = str(lvl_data.get("subtitle", ""))
	var hint = str(lvl_data.get("hint", ""))
	if hud and hud.has_method("update_hud"):
		hud.update_hud(title, subtitle, deaths_count, hint)

	death_timer_id += 1
	var this_death_id = death_timer_id
	# Auto-restart after short delay (0.32s)
	await get_tree().create_timer(0.32).timeout
	if this_death_id == death_timer_id and (intro_layer == null or not intro_layer.visible) and not is_transitioning:
		restart_level()

func _on_level_cleared() -> void:
	if is_transitioning:
		return
	is_transitioning = true
	death_timer_id += 1
	transition_id += 1
	var this_trans_id = transition_id

	if player:
		player.set_physics_process(false)
		player.velocity = Vector2.ZERO

	var next_lvl = current_level_index + 1
	if current_level_index == 0:
		save_data["entrance_cleared"] = true
		var cur_max = int(save_data.get("max_unlocked_level", 0))
		save_data["max_unlocked_level"] = max(cur_max, 1)
		save_save_data()
		sync_progression_ui()
		AudioManager.play_win()
		spawn_floating_text("ENTRANCE TEST PASSED! 🎓 LEVEL 1 UNLOCKED!", current_door.position + Vector2(-60, -35), Color(0.2, 0.98, 0.4))
	else:
		var cur_max = int(save_data.get("max_unlocked_level", 1))
		if next_lvl > cur_max and next_lvl < levels_data.size():
			save_data["max_unlocked_level"] = next_lvl
			save_save_data()
			sync_progression_ui()
			spawn_floating_text("LEVEL CLEAR! LEVEL %d UNLOCKED! 🔓" % next_lvl, current_door.position + Vector2(-40, -30), Color(0.2, 0.98, 0.4))
		else:
			spawn_floating_text("LEVEL CLEAR! 🎉", current_door.position + Vector2(0, -30), Color(0.2, 0.98, 0.4))

	await get_tree().create_timer(0.85).timeout
	if this_trans_id != transition_id:
		return

	if next_lvl < levels_data.size():
		load_level(next_lvl)
	else:
		spawn_floating_text("YOU BEAT THE GAME! 🏆", Vector2(400, 200), Color(1, 0.8, 0.2))

func shake_camera(_intensity: float) -> void:
	# Screen vibration / shake effect removed as requested
	pass

func spawn_floating_text(text: String, pos: Vector2, color: Color) -> void:
	var ft = FLOATING_TEXT_SCENE.instantiate()
	ft.position = pos
	ft.call("setup", text, color)
	add_child(ft)

func _physics_process(_delta: float) -> void:
	# Don't run game logic or hotkeys while intro or modals are shown
	if intro_layer and intro_layer.visible:
		return
	if hud and hud.has_node("LevelSelectModal") and hud.get_node("LevelSelectModal").visible:
		return

	# Quick restart hotkey (only on single keypress, never repeatedly while held)
	if Input.is_action_just_pressed("restart") and not is_transitioning:
		restart_level()

	# Process troll manager
	troll_manager.check_triggers(just_jumped_this_frame)
	just_jumped_this_frame = false

	# Ensure camera stays calm without vibration
	camera.offset = Vector2.ZERO

	# Check off-screen fall death
	if player and not bool(player.get("is_dead")):
		if player.position.y > 520.0 or player.position.y < -150.0:
			player.call("kill", "Fell into the void!")

	# Update darkness spotlight center
	if is_dark_room and darkness_rect and darkness_rect.visible and player:
		darkness_material.set_shader_parameter("player_pos", player.position)
