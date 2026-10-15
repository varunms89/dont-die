class_name TrollManager
extends RefCounted

var player: Player
var door: ExitDoor
var blocks_by_id: Dictionary = {}
var spikes_by_id: Dictionary = {}
var triggers: Array = []
var executed_trigger_ids: Dictionary = {}
var main_node: Node2D

func init(p_player: Player, p_door: ExitDoor, p_blocks: Array[LevelBlock], p_spikes: Array[Spike], p_triggers: Array, p_main: Node2D) -> void:
	player = p_player
	door = p_door
	main_node = p_main
	triggers = p_triggers
	blocks_by_id.clear()
	spikes_by_id.clear()
	executed_trigger_ids.clear()

	for b in p_blocks:
		if b.block_id != "":
			blocks_by_id[b.block_id] = b

	for s in p_spikes:
		if s.spike_id != "":
			spikes_by_id[s.spike_id] = s

func reset() -> void:
	executed_trigger_ids.clear()

func check_triggers(just_jumped: bool) -> void:
	if player == null or player.is_dead:
		return

	for trigger in triggers:
		var trig_id: String = str(trigger.get("id", ""))
		if executed_trigger_ids.has(trig_id):
			continue

		var condition: String = str(trigger.get("condition", ""))
		var params: Dictionary = trigger.get("params", {})
		var should_fire: bool = false

		match condition:
			"player_x_gt":
				if player.position.x > float(params.get("x", 0.0)):
					should_fire = true
			"player_x_lt":
				if player.position.x < float(params.get("x", 0.0)):
					should_fire = true
			"distance_to_door":
				if door != null:
					var dist: float = player.position.distance_to(door.position + (door.door_size / 2.0))
					if dist < float(params.get("distance", 100.0)):
						should_fire = true
			"distance_to_point":
				var pt: Vector2 = Vector2(float(params.get("x", 0.0)), float(params.get("y", 0.0)))
				if player.position.distance_to(pt) < float(params.get("distance", 100.0)):
					should_fire = true
			"player_jump":
				if just_jumped:
					var min_x = params.get("minX", null)
					var max_x = params.get("maxX", null)
					var in_bounds: bool = true
					if min_x != null and player.position.x < float(min_x):
						in_bounds = false
					if max_x != null and player.position.x > float(max_x):
						in_bounds = false
					if in_bounds:
						should_fire = true

		if should_fire:
			executed_trigger_ids[trig_id] = true
			execute_action(trigger)

func execute_action(trigger: Dictionary) -> void:
	var action: String = str(trigger.get("action", ""))
	var params: Dictionary = trigger.get("params", {})

	if player != null:
		player.set_shocked(0.6)

	match action:
		"drop_blocks":
			var ids = params.get("blockIds", [])
			var delay: float = float(params.get("delay", 0.15))
			for bid in ids:
				if blocks_by_id.has(bid):
					blocks_by_id[bid].trigger_fall(0.0, delay)
			AudioManager.play_trap()
			if main_node.has_method("shake_camera"):
				main_node.shake_camera(6.0)

		"raise_spikes":
			var ids = params.get("spikeIds", [])
			var speed: float = float(params.get("speed", -350.0))
			for sid in ids:
				if spikes_by_id.has(sid):
					spikes_by_id[sid].pop_up(speed)
			AudioManager.play_troll()
			if main_node.has_method("shake_camera"):
				main_node.shake_camera(8.0)

		"flee_door":
			if door != null:
				var target_x: float = float(params.get("targetX", door.position.x + 220.0))
				var speed: float = float(params.get("speed", 380.0))
				var msg: String = str(params.get("message", "BYE! 💨"))
				door.flee_to(target_x, speed)
				spawn_floating_text(msg, door.position + Vector2(0, -20), Color(0.98, 0.75, 0.15))

		"jump_spikes":
			var ids = params.get("spikeIds", [])
			var force: float = float(params.get("force", 480.0))
			for sid in ids:
				if spikes_by_id.has(sid):
					spikes_by_id[sid].jump(force)
			AudioManager.play_jump()

		"crush_ceiling":
			var ids = params.get("blockIds", [])
			var speed: float = float(params.get("speed", 500.0))
			for bid in ids:
				if blocks_by_id.has(bid):
					blocks_by_id[bid].trigger_fall(speed, 0.0)
			AudioManager.play_trap()
			spawn_floating_text("CRUSH! 💥", player.position + Vector2(0, -30), Color(0.95, 0.25, 0.25))
			if main_node.has_method("shake_camera"):
				main_node.shake_camera(12.0)

		"flip_gravity":
			if player != null:
				player.gravity_dir = -player.gravity_dir
				AudioManager.play_troll()
				spawn_floating_text("GRAVITY FLIPPED! 🙃", player.position + Vector2(0, -30), Color(0.65, 0.35, 0.95))
				if main_node.has_method("shake_camera"):
					main_node.shake_camera(10.0)

		"invert_controls":
			if player != null:
				player.inverted_controls = !player.inverted_controls
				AudioManager.play_troll()
				var msg: String = str(params.get("message", "CONTROLS INVERTED! 🔄"))
				spawn_floating_text(msg, player.position + Vector2(0, -30), Color(0.98, 0.55, 0.15))
				if main_node.has_method("shake_camera"):
					main_node.shake_camera(8.0)

		"fake_door_reveal":
			if door != null:
				var real_x: float = float(params.get("realDoorX", door.position.x))
				var real_y: float = float(params.get("realDoorY", door.position.y))
				door.reveal_fake(real_x, real_y)
				spawn_floating_text("SIKE! 😂", door.position + Vector2(0, -25), Color(0.95, 0.25, 0.25))
				if main_node.has_method("shake_camera"):
					main_node.shake_camera(10.0)

		"rocket_door":
			if door != null:
				var new_x: float = float(params.get("newX", door.position.x))
				var new_y: float = float(params.get("newY", door.position.y))
				door.launch_rocket(new_x, new_y)
				spawn_floating_text("TO THE MOON! 🚀", door.position + Vector2(0, -20), Color(0.25, 0.75, 0.95))
				if main_node.has_method("shake_camera"):
					main_node.shake_camera(14.0)

		"troll_message":
			var text: String = str(params.get("text", "LOL! 😈"))
			spawn_floating_text(text, player.position + Vector2(0, -30), Color(0.98, 0.25, 0.45))
			AudioManager.play_troll()

		"shake_camera":
			var intensity: float = float(params.get("intensity", 15.0))
			if main_node.has_method("shake_camera"):
				main_node.shake_camera(intensity)
			AudioManager.play_trap()

func spawn_floating_text(text: String, pos: Vector2, color: Color) -> void:
	if main_node and main_node.has_method("spawn_floating_text"):
		main_node.spawn_floating_text(text, pos, color)
