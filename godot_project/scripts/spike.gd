extends Area2D

@export var spike_id: String = ""
@export var direction: String = "up" # up, down, left, right
@export var spike_size: Vector2 = Vector2(24, 24)
@export var jumps_with_player: bool = false
@export var is_hidden: bool = false
@export var spike_color: Color = Color(0.95, 0.25, 0.35)

var initial_pos: Vector2 = Vector2.ZERO
var is_moving: bool = false
var velocity_y: float = 0.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	initial_pos = position
	body_entered.connect(_on_body_entered)
	setup_spike()

func setup_spike() -> void:
	if collision_shape and collision_shape.shape is RectangleShape2D:
		# Inset hitbox for fair platforming feel
		var inset_x: float = spike_size.x * 0.2
		var inset_y: float = spike_size.y * 0.2
		var fair_w: float = spike_size.x - (inset_x * 2.0)
		var fair_h: float = spike_size.y - (inset_y * 1.5)
		var y_off = (inset_y * 0.5) if direction == "up" else (-(inset_y * 0.5) if direction == "down" else 0.0)
		collision_shape.position = Vector2(spike_size.x / 2.0, (spike_size.y / 2.0) + y_off)

	visible = not is_hidden
	queue_redraw()

func jump(force: float = 480.0) -> void:
	is_moving = true
	velocity_y = -force if direction == "up" else force

func pop_up(speed: float = -350.0) -> void:
	is_hidden = false
	visible = true
	is_moving = true
	velocity_y = speed if direction == "up" else -speed
	for body in get_overlapping_bodies():
		_on_body_entered(body)

func reset_spike() -> void:
	position = initial_pos
	is_moving = false
	velocity_y = 0.0
	visible = not is_hidden
	queue_redraw()

func _physics_process(delta: float) -> void:
	if is_moving:
		velocity_y += (1100.0 if direction == "up" else -1100.0) * delta
		position.y += velocity_y * delta

		# Return to initial ground when falling down (floor) or returning up (ceiling)
		if direction == "up" and position.y >= initial_pos.y:
			position.y = initial_pos.y
			velocity_y = 0.0
			is_moving = false
		elif direction == "down" and position.y <= initial_pos.y:
			position.y = initial_pos.y
			velocity_y = 0.0
			is_moving = false

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("kill") and not body.get("is_dead") and visible:
		body.kill("Impaled on spikes!")

func _draw() -> void:
	if not visible:
		return

	var tooth_w: float = 24.0
	var count: int = max(1, int(spike_size.x / tooth_w))
	var step_w: float = spike_size.x / float(count)

	for i in range(count):
		var x0: float = i * step_w
		var x1: float = (i + 1) * step_w
		var xm: float = (x0 + x1) / 2.0

		var points: PackedVector2Array = PackedVector2Array()
		if direction == "up":
			points.append(Vector2(x0, spike_size.y))
			points.append(Vector2(xm, 0))
			points.append(Vector2(x1, spike_size.y))
		elif direction == "down":
			points.append(Vector2(x0, 0))
			points.append(Vector2(xm, spike_size.y))
			points.append(Vector2(x1, 0))
		elif direction == "left":
			points.append(Vector2(spike_size.x, 0))
			points.append(Vector2(0, spike_size.y / 2.0))
			points.append(Vector2(spike_size.x, spike_size.y))
		else: # right
			points.append(Vector2(0, 0))
			points.append(Vector2(spike_size.x, spike_size.y / 2.0))
			points.append(Vector2(0, spike_size.y))

		draw_colored_polygon(points, spike_color)
		draw_polyline(points, Color.WHITE, 1.0)
