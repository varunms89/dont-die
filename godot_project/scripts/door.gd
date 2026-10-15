extends Area2D

signal entered()

@export var door_size: Vector2 = Vector2(32, 44)
@export var frame_color: Color = Color(0.98, 0.80, 0.08)
@export var portal_color_1: Color = Color(0.92, 0.28, 0.6)
@export var portal_color_2: Color = Color(0.22, 0.74, 0.97)

var initial_pos: Vector2 = Vector2.ZERO
var is_fake: bool = false
var is_fleeing: bool = false
var target_pos_x: float = 0.0
var flee_speed: float = 380.0

var is_rocket: bool = false
var rocket_vy: float = 0.0
var rocket_target_pos: Vector2 = Vector2.ZERO

var pulse_time: float = 0.0
var is_opened: bool = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	initial_pos = position
	body_entered.connect(_on_body_entered)
	setup_door()

func setup_door() -> void:
	if collision_shape and collision_shape.shape is RectangleShape2D:
		(collision_shape.shape as RectangleShape2D).size = door_size
		collision_shape.position = door_size / 2.0
	queue_redraw()

func flee_to(target_x: float, speed: float = 380.0) -> void:
	is_fleeing = true
	target_pos_x = target_x
	flee_speed = speed
	AudioManager.play_troll()

func launch_rocket(new_x: float, new_y: float) -> void:
	is_rocket = true
	rocket_vy = -700.0
	rocket_target_pos = Vector2(new_x, new_y)
	AudioManager.play_troll()

func reveal_fake(real_door_x: float, real_door_y: float) -> void:
	is_fake = true
	AudioManager.play_troll()
	await get_tree().create_timer(0.8).timeout
	position = Vector2(real_door_x, real_door_y)
	is_fake = false
	AudioManager.play_door()

func reset_door() -> void:
	position = initial_pos
	is_fake = false
	is_fleeing = false
	is_rocket = false
	rocket_vy = 0.0
	is_opened = false
	visible = true
	queue_redraw()

func _physics_process(delta: float) -> void:
	pulse_time += delta

	# Fleeing motion
	if is_fleeing:
		var dx: float = target_pos_x - position.x
		if abs(dx) > 4.0:
			position.x += sign(dx) * min(abs(dx), flee_speed * delta)
		else:
			is_fleeing = false

	# Rocket door motion
	if is_rocket:
		position.y += rocket_vy * delta
		if position.y < -100.0 and rocket_target_pos != Vector2.ZERO:
			position.x = rocket_target_pos.x
			rocket_vy = 300.0
		if rocket_vy > 0.0 and position.y >= rocket_target_pos.y:
			position.y = rocket_target_pos.y
			is_rocket = false
			AudioManager.play_door()

	queue_redraw()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("kill") and not body.get("is_dead") and not is_opened:
		if is_fake or is_fleeing:
			return
		is_opened = true
		AudioManager.play_win()
		emit_signal("entered")

func _draw() -> void:
	var rect: Rect2 = Rect2(Vector2.ZERO, door_size)
	draw_rect(rect, frame_color, false, 3.0)

	var inner_rect: Rect2 = Rect2(3.0, 3.0, door_size.x - 6.0, door_size.y - 6.0)
	var glow_factor: float = 0.5 + 0.5 * sin(pulse_time * 6.0)
	var portal_col: Color = portal_color_1.lerp(portal_color_2, glow_factor)
	draw_rect(inner_rect, portal_col, true)

	var center: Vector2 = door_size / 2.0
	var ring_r: float = (door_size.x * 0.3) * (0.8 + 0.2 * sin(pulse_time * 8.0))
	draw_circle(center, ring_r, Color(1, 1, 1, 0.4))
	draw_circle(center, ring_r * 0.5, Color(1, 1, 1, 0.7))
