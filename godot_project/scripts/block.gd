extends AnimatableBody2D

signal crumbled(block: Node2D)
signal stepped_on(block: Node2D)

@export var block_id: String = ""
@export var block_type: String = "solid" # solid, crumble, fake, invisible, bouncy, ice
@export var block_size: Vector2 = Vector2(80, 40)
@export var color_base: Color = Color(0.12, 0.06, 0.21)
@export var color_top: Color = Color(0.75, 0.52, 0.98)

var initial_pos: Vector2 = Vector2.ZERO
var is_falling: bool = false
var fall_velocity_y: float = 0.0
var shake_timer: float = 0.0
var is_revealed: bool = true

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	initial_pos = position
	setup_block()

func setup_block() -> void:
	if collision_shape:
		var shape_inst = RectangleShape2D.new()
		shape_inst.size = block_size
		collision_shape.shape = shape_inst
		collision_shape.position = block_size / 2.0

	if block_type == "fake":
		# Fake block: player passes right through!
		collision_layer = 0
		collision_mask = 0
	elif block_type == "invisible":
		is_revealed = false
		collision_layer = 2
		collision_mask = 1
	else:
		collision_layer = 2
		collision_mask = 1

	queue_redraw()

func trigger_crumble() -> void:
	if block_type == "crumble" and not is_falling and shake_timer <= 0.0:
		shake_timer = 0.35
		AudioManager.play_trap()

func trigger_fall(speed: float = 0.0, delay: float = 0.15) -> void:
	if delay > 0.0:
		shake_timer = delay
	else:
		is_falling = true
		fall_velocity_y = speed

func reveal() -> void:
	is_revealed = true
	queue_redraw()

func reset_block() -> void:
	position = initial_pos
	is_falling = false
	fall_velocity_y = 0.0
	shake_timer = 0.0
	if block_type == "invisible":
		is_revealed = false
	queue_redraw()

func _physics_process(delta: float) -> void:
	# Timer before falling (no screen shake or block jitter)
	if shake_timer > 0.0:
		shake_timer -= delta
		position.x = initial_pos.x
		queue_redraw()
		if shake_timer <= 0.0:
			is_falling = true
			emit_signal("crumbled", self)

	# Falling motion
	if is_falling and shake_timer <= 0.0:
		fall_velocity_y += 1200.0 * delta
		position.y += fall_velocity_y * delta

		# Check if falling ceiling squishes the player (not crumble floors)
		if fall_velocity_y > 100.0 and block_type != "crumble":
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsShapeQueryParameters2D.new()
			var rect_shape = RectangleShape2D.new()
			rect_shape.size = block_size
			query.shape = rect_shape
			query.transform = Transform2D(0.0, position + (block_size / 2.0))
			query.collision_mask = 1 # Player layer
			var results = space_state.intersect_shape(query, 4)
			for res in results:
				var collider = res.collider
				if collider.has_method("kill") and not collider.get("is_dead"):
					# Only crush if the block started above the player
					if initial_pos.y < collider.position.y:
						collider.kill("Squashed by falling ceiling!")

func _draw() -> void:
	if block_type == "invisible" and not is_revealed:
		return

	var rect: Rect2 = Rect2(Vector2.ZERO, block_size)

	if block_type == "bouncy":
		# Trampoline block: vibrant spring cyan with chevron stripes
		draw_rect(rect, Color(0.05, 0.25, 0.35), true)
		draw_rect(rect, Color(0.2, 0.9, 0.95), false, 2.0)
		draw_line(Vector2(4, 4), Vector2(block_size.x - 4, 4), Color(0.2, 0.9, 0.95), 3.0)
	elif block_type == "ice":
		# Slippery icy runway
		draw_rect(rect, Color(0.15, 0.3, 0.45, 0.9), true)
		draw_rect(rect, Color(0.6, 0.85, 1.0), false, 1.5)
		draw_line(Vector2(0, 2), Vector2(block_size.x, 2), Color(0.8, 0.95, 1.0), 2.5)
	elif block_type == "crumble":
		# Orange crumbling stone
		var crumb_col = Color(0.7, 0.35, 0.1) if shake_timer <= 0.0 else Color(0.95, 0.55, 0.2)
		draw_rect(rect, crumb_col, true)
		draw_rect(rect, Color(1.0, 0.6, 0.2), false, 1.5)
		draw_line(Vector2(block_size.x * 0.3, 0), Vector2(block_size.x * 0.45, block_size.y * 0.7), Color(0.2, 0.1, 0.05), 1.5)
		if shake_timer > 0.0:
			draw_line(Vector2(block_size.x * 0.6, 0), Vector2(block_size.x * 0.5, block_size.y * 0.85), Color(0.15, 0.08, 0.03), 1.5)
			draw_line(Vector2(block_size.x * 0.1, block_size.y * 0.3), Vector2(block_size.x * 0.35, block_size.y * 0.75), Color(0.15, 0.08, 0.03), 1.5)
	elif block_type == "fake":
		# Fake block: subtle transparency shimmer
		var shimmer_a: float = 0.85 + sin(Time.get_ticks_msec() * 0.005) * 0.08
		var fake_base = Color(color_base.r, color_base.g, color_base.b, shimmer_a)
		var fake_top = Color(color_top.r, color_top.g, color_top.b, shimmer_a)
		draw_rect(rect, fake_base, true)
		draw_rect(rect, fake_top, false, 1.0)
		if block_size.y > 6.0:
			draw_rect(Rect2(Vector2.ZERO, Vector2(block_size.x, 4.0)), fake_top, true)
	else:
		# Standard Solid Block
		draw_rect(rect, color_base, true)
		draw_rect(rect, color_top, false, 1.0)
		if block_size.y > 6.0:
			draw_rect(Rect2(Vector2.ZERO, Vector2(block_size.x, 4.0)), color_top, true)
