class_name Player
extends CharacterBody2D

signal died()
signal jumped()
signal landed()

# Physics constants matching original engine
const MOVE_SPEED: float = 240.0
const JUMP_FORCE: float = 520.0
const GRAVITY_ACCEL: float = 1350.0
const MAX_FALL_SPEED: float = 750.0
const NORMAL_FRICTION: float = 0.72
const ICE_FRICTION: float = 0.985
const AIR_FRICTION: float = 0.88

# Timers
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var shocked_timer: float = 0.0
var blink_timer: float = 2.0
var is_blinking: bool = false

# Troll modifiers & state
var gravity_dir: int = 1 # 1 = down, -1 = up
var inverted_controls: bool = false
var is_on_ice: bool = false
var is_dead: bool = false
var facing_dir: int = 1 # 1 = right, -1 = left
var was_grounded_last_frame: bool = false

# Visual squash & stretch
var squash_scale: Vector2 = Vector2.ONE

# Dimensions
const WIDTH: float = 24.0
const HEIGHT: float = 26.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	# Configure collision shape to 24x26
	if collision_shape and collision_shape.shape is RectangleShape2D:
		(collision_shape.shape as RectangleShape2D).size = Vector2(WIDTH, HEIGHT)

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Handle timers
	if shocked_timer > 0.0:
		shocked_timer -= delta
	if coyote_timer > 0.0:
		coyote_timer -= delta
	if jump_buffer_timer > 0.0:
		jump_buffer_timer -= delta

	# Blinking timer
	blink_timer -= delta
	if blink_timer <= 0.0:
		if is_blinking:
			is_blinking = false
			blink_timer = randf_range(2.0, 4.0)
		else:
			is_blinking = true
			blink_timer = 0.12

	# Input handling
	var input_left: bool = Input.is_action_pressed("move_left") or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT)
	var input_right: bool = Input.is_action_pressed("move_right") or Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)
	var jump_just_pressed: bool = Input.is_action_just_pressed("jump") or Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP)
	var jump_released: bool = Input.is_action_just_released("jump")

	# Troll: Inverted Controls
	if inverted_controls:
		var temp = input_left
		input_left = input_right
		input_right = temp

	# Jump buffer
	if jump_just_pressed:
		jump_buffer_timer = 0.12

	# Ground check based on gravity direction
	up_direction = Vector2.UP if gravity_dir == 1 else Vector2.DOWN
	var currently_grounded: bool = is_on_floor() if gravity_dir == 1 else is_on_ceiling()

	if currently_grounded:
		coyote_timer = 0.10
		if not was_grounded_last_frame:
			# Landed! Squash effect
			squash_scale = Vector2(1.25, 0.75)
			emit_signal("landed")
	was_grounded_last_frame = currently_grounded

	# Horizontal Movement & Acceleration
	var target_vx: float = 0.0
	if input_left:
		target_vx -= MOVE_SPEED
		facing_dir = -1
	if input_right:
		target_vx += MOVE_SPEED
		facing_dir = 1

	var current_friction: float = ICE_FRICTION if is_on_ice else (NORMAL_FRICTION if currently_grounded else AIR_FRICTION)
	if target_vx != 0.0:
		var accel_rate: float = 0.08 if is_on_ice else 0.45
		velocity.x += (target_vx - velocity.x) * accel_rate
	else:
		velocity.x *= current_friction
		if abs(velocity.x) < 2.0:
			velocity.x = 0.0

	# Jump execution with buffering & coyote time
	var can_jump: bool = currently_grounded or coyote_timer > 0.0
	if jump_buffer_timer > 0.0 and can_jump:
		velocity.y = -JUMP_FORCE * gravity_dir
		coyote_timer = 0.0
		jump_buffer_timer = 0.0
		squash_scale = Vector2(0.75, 1.35)
		AudioManager.play_jump()
		emit_signal("jumped")

	# Variable jump height (releasing jump cuts vertical velocity)
	if jump_released:
		if gravity_dir == 1 and velocity.y < -150.0:
			velocity.y *= 0.45
		elif gravity_dir == -1 and velocity.y > 150.0:
			velocity.y *= 0.45

	# Apply Gravity
	velocity.y += GRAVITY_ACCEL * gravity_dir * delta
	if gravity_dir == 1 and velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
	elif gravity_dir == -1 and velocity.y < -MAX_FALL_SPEED:
		velocity.y = -MAX_FALL_SPEED

	# Execute Physics Move
	move_and_slide()

	# Handle smooth return of squash and stretch
	squash_scale.x = move_toward(squash_scale.x, 1.0, delta * 8.0)
	squash_scale.y = move_toward(squash_scale.y, 1.0, delta * 8.0)

	queue_redraw()

func apply_bounce(multiplier: float = 1.35) -> void:
	velocity.y = -JUMP_FORCE * multiplier * gravity_dir
	squash_scale = Vector2(0.65, 1.4)
	coyote_timer = 0.0
	jump_buffer_timer = 0.0
	AudioManager.play_jump()

func kill(reason: String = "") -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	AudioManager.play_death()
	emit_signal("died")
	queue_redraw()

func respawn(start_pos: Vector2, p_gravity_dir: int = 1) -> void:
	position = start_pos
	velocity = Vector2.ZERO
	is_dead = false
	gravity_dir = p_gravity_dir
	inverted_controls = false
	is_on_ice = false
	squash_scale = Vector2.ONE
	shocked_timer = 0.0
	coyote_timer = 0.0
	jump_buffer_timer = 0.0
	was_grounded_last_frame = false
	queue_redraw()

func set_shocked(duration: float = 0.6) -> void:
	shocked_timer = duration
	queue_redraw()

func _draw() -> void:
	if is_dead:
		return

	# Apply squash and stretch scaling
	var half_w: float = (WIDTH / 2.0) * squash_scale.x
	var half_h: float = (HEIGHT / 2.0) * squash_scale.y
	var body_rect: Rect2 = Rect2(-half_w, -half_h, half_w * 2.0, half_h * 2.0)

	# Body color: Bright vibrant hero yellow
	var body_color: Color = Color(0.98, 0.80, 0.08, 1.0)
	var border_color: Color = Color(0.85, 0.65, 0.05, 1.0)
	draw_rect(body_rect, body_color, true)
	draw_rect(body_rect, border_color, false, 1.5)

	# Cute Eyes
	var eye_offset_x: float = 4.0 * facing_dir
	var eye_y: float = -3.0 if gravity_dir == 1 else 3.0

	if shocked_timer > 0.0:
		# Shocked O_O Expression!
		draw_circle(Vector2(eye_offset_x - 5.0, eye_y), 4.5, Color.WHITE)
		draw_circle(Vector2(eye_offset_x + 5.0, eye_y), 4.5, Color.WHITE)
		draw_circle(Vector2(eye_offset_x - 5.0 + facing_dir, eye_y), 2.0, Color.BLACK)
		draw_circle(Vector2(eye_offset_x + 5.0 + facing_dir, eye_y), 2.0, Color.BLACK)
		# Open O mouth
		draw_circle(Vector2(eye_offset_x, eye_y + (5.0 * gravity_dir)), 2.5, Color(0.2, 0.1, 0.1))
	elif is_blinking:
		# Blinking closed line eyes
		draw_line(Vector2(eye_offset_x - 6.0, eye_y), Vector2(eye_offset_x - 2.0, eye_y), Color.BLACK, 2.0)
		draw_line(Vector2(eye_offset_x + 2.0, eye_y), Vector2(eye_offset_x + 6.0, eye_y), Color.BLACK, 2.0)
	else:
		# Normal cute animated eyes
		draw_circle(Vector2(eye_offset_x - 4.0, eye_y), 3.5, Color.WHITE)
		draw_circle(Vector2(eye_offset_x + 4.0, eye_y), 3.5, Color.WHITE)
		draw_circle(Vector2(eye_offset_x - 4.0 + (facing_dir * 1.5), eye_y), 1.8, Color.BLACK)
		draw_circle(Vector2(eye_offset_x + 4.0 + (facing_dir * 1.5), eye_y), 1.8, Color.BLACK)
