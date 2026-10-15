extends CharacterBody2D

signal died()
signal jumped()
signal landed()
signal dashed()

# Physics constants matching original engine
const MOVE_SPEED: float = 240.0
const JUMP_FORCE: float = 520.0
const GRAVITY_ACCEL: float = 1350.0
const MAX_FALL_SPEED: float = 750.0
const NORMAL_FRICTION: float = 0.72
const ICE_FRICTION: float = 0.985
const AIR_FRICTION: float = 0.88

# Abilities: Double Jump & Air Dash
var max_jumps: int = 2
var jumps_left: int = 2
var can_dash: bool = true
var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cooldown: float = 0.0
const DASH_DURATION: float = 0.16
const DASH_SPEED: float = 540.0

# Ghost Trail Effect
var ghost_trails: Array[Dictionary] = []
var ghost_spawn_timer: float = 0.0

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
	if collision_shape and collision_shape.shape is RectangleShape2D:
		(collision_shape.shape as RectangleShape2D).size = Vector2(WIDTH, HEIGHT)

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Handle cooldowns & timers
	if shocked_timer > 0.0:
		shocked_timer -= delta
	if coyote_timer > 0.0:
		coyote_timer -= delta
	if jump_buffer_timer > 0.0:
		jump_buffer_timer -= delta
	if dash_cooldown > 0.0:
		dash_cooldown -= delta

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
	var dash_just_pressed: bool = Input.is_action_just_pressed("dash") or Input.is_key_pressed(KEY_SHIFT) or Input.is_key_pressed(KEY_J)

	# Troll: Inverted Controls
	if inverted_controls:
		var temp = input_left
		input_left = input_right
		input_right = temp

	# Ground check based on gravity direction (up_direction handles floor detection)
	up_direction = Vector2.UP if gravity_dir == 1 else Vector2.DOWN
	var currently_grounded: bool = is_on_floor()

	if currently_grounded:
		coyote_timer = 0.10
		jumps_left = max_jumps
		can_dash = true
		if not was_grounded_last_frame:
			# Landed! Squash effect
			squash_scale = Vector2(1.25, 0.75)
			emit_signal("landed")
	was_grounded_last_frame = currently_grounded

	# Dash Trigger
	if dash_just_pressed and can_dash and dash_cooldown <= 0.0 and not is_dashing:
		is_dashing = true
		dash_timer = DASH_DURATION
		dash_cooldown = 0.45
		can_dash = false
		squash_scale = Vector2(1.5, 0.65)
		velocity.x = DASH_SPEED * facing_dir
		velocity.y = 0.0
		AudioManager.play_dash()
		emit_signal("dashed")

	# While Dashing
	if is_dashing:
		dash_timer -= delta
		velocity.x = DASH_SPEED * facing_dir
		velocity.y = 0.0

		# Record dash ghost trail
		ghost_spawn_timer -= delta
		if ghost_spawn_timer <= 0.0:
			ghost_spawn_timer = 0.03
			ghost_trails.append({
				"pos": position,
				"scale": squash_scale,
				"alpha": 0.8,
				"color": Color(0.2, 0.85, 1.0) # Neon cyan trail
			})

		if dash_timer <= 0.0:
			is_dashing = false
			velocity.x = MOVE_SPEED * facing_dir * 0.8
	else:
		# Standard Horizontal Movement & Acceleration
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

		# Jump buffer
		if jump_just_pressed:
			jump_buffer_timer = 0.12

		# Jump & Double Jump Logic
		var can_first_jump: bool = currently_grounded or coyote_timer > 0.0
		if jump_buffer_timer > 0.0:
			if can_first_jump:
				# First Jump
				velocity.y = -JUMP_FORCE * gravity_dir
				coyote_timer = 0.0
				jump_buffer_timer = 0.0
				jumps_left = max_jumps - 1
				squash_scale = Vector2(0.75, 1.35)
				AudioManager.play_jump()
				emit_signal("jumped")
			elif jumps_left > 0:
				# Double Jump!
				velocity.y = -JUMP_FORCE * 0.95 * gravity_dir
				jumps_left -= 1
				jump_buffer_timer = 0.0
				squash_scale = Vector2(0.7, 1.4)
				AudioManager.play_double_jump()
				# Spawn golden double-jump ring trail
				ghost_trails.append({
					"pos": position,
					"scale": Vector2(1.2, 1.2),
					"alpha": 0.9,
					"color": Color(1.0, 0.8, 0.2)
				})
				emit_signal("jumped")

		# Variable jump height
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

	# Process Slide Collisions (crumble, bounce, ice, reveal)
	var on_ice_surface: bool = false
	for i in range(get_slide_collision_count()):
		var col = get_slide_collision(i)
		var collider = col.get_collider()
		if collider:
			if collider.has_method("reveal"):
				collider.reveal()
			if collider.get("block_type") == "ice":
				on_ice_surface = true
			if col.get_normal().dot(up_direction) > 0.65:
				if collider.has_method("trigger_crumble"):
					collider.trigger_crumble()
				if collider.get("block_type") == "bouncy":
					apply_bounce(1.42)
	is_on_ice = on_ice_surface

	# Update Ghost Trails
	for i in range(ghost_trails.size() - 1, -1, -1):
		var gt = ghost_trails[i]
		gt["alpha"] -= delta * 3.5
		if gt["alpha"] <= 0.0:
			ghost_trails.remove_at(i)

	# Handle smooth return of squash and stretch
	squash_scale.x = move_toward(squash_scale.x, 1.0, delta * 8.0)
	squash_scale.y = move_toward(squash_scale.y, 1.0, delta * 8.0)

	queue_redraw()

func apply_bounce(multiplier: float = 1.35) -> void:
	velocity.y = -JUMP_FORCE * multiplier * gravity_dir
	squash_scale = Vector2(0.65, 1.4)
	coyote_timer = 0.0
	jump_buffer_timer = 0.0
	jumps_left = max_jumps
	AudioManager.play_jump()

func kill(reason: String = "") -> void:
	if is_dead:
		return
	is_dead = true
	is_dashing = false
	velocity = Vector2.ZERO
	ghost_trails.clear()
	AudioManager.play_death()
	emit_signal("died")
	queue_redraw()

func respawn(start_pos: Vector2, p_gravity_dir: int = 1) -> void:
	position = start_pos
	velocity = Vector2.ZERO
	is_dead = false
	is_dashing = false
	can_dash = true
	dash_cooldown = 0.0
	max_jumps = 2
	jumps_left = max_jumps
	gravity_dir = p_gravity_dir
	inverted_controls = false
	is_on_ice = false
	squash_scale = Vector2.ONE
	shocked_timer = 0.0
	coyote_timer = 0.0
	jump_buffer_timer = 0.0
	was_grounded_last_frame = false
	ghost_trails.clear()
	queue_redraw()

func set_shocked(duration: float = 0.6) -> void:
	shocked_timer = duration
	queue_redraw()

func _draw() -> void:
	if is_dead:
		return

	# Draw Ghost Trails (afterimages behind the player)
	for gt in ghost_trails:
		var rel_pos: Vector2 = gt["pos"] - position
		var gt_scale: Vector2 = gt["scale"]
		var hw_g: float = (WIDTH / 2.0) * gt_scale.x
		var hh_g: float = (HEIGHT / 2.0) * gt_scale.y
		var g_rect: Rect2 = Rect2(rel_pos.x - hw_g, rel_pos.y - hh_g, hw_g * 2.0, hh_g * 2.0)
		var g_col: Color = gt["color"]
		g_col.a = gt["alpha"] * 0.4
		draw_rect(g_rect, g_col, true)
		draw_rect(g_rect, Color(g_col.r, g_col.g, g_col.b, gt["alpha"] * 0.7), false, 1.5)

	# Main Player Character
	var half_w: float = (WIDTH / 2.0) * squash_scale.x
	var half_h: float = (HEIGHT / 2.0) * squash_scale.y
	var body_rect: Rect2 = Rect2(-half_w, -half_h, half_w * 2.0, half_h * 2.0)

	# Body color: Bright vibrant hero yellow, with cyan dash glow if dashing
	var body_color: Color = Color(0.4, 0.95, 1.0) if is_dashing else Color(0.98, 0.80, 0.08)
	var border_color: Color = Color(0.1, 0.6, 0.9) if is_dashing else Color(0.85, 0.65, 0.05)
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
