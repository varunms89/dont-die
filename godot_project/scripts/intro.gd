extends Control

signal play_pressed()
signal level_select_pressed()

@onready var title_label: Label = $VBox/TitleLabel
@onready var subtitle_label: Label = $VBox/SubtitleLabel
@onready var play_btn: Button = $VBox/ButtonContainer/PlayButton
@onready var select_btn: Button = $VBox/ButtonContainer/SelectButton
@onready var controls_label: Label = $VBox/ControlsLabel

var anim_time: float = 0.0
var hero_jump_timer: float = 0.0
var hero_y_offset: float = 0.0
var hero_squash: Vector2 = Vector2.ONE
var hero_blinking: bool = false
var hero_shocked: bool = false

func _ready() -> void:
	if play_btn:
		play_btn.pressed.connect(_on_play_pressed)
	if select_btn:
		select_btn.pressed.connect(_on_select_pressed)

func show_intro_screen() -> void:
	visible = true
	set_process(true)
	AudioManager.play_intro_song()
	queue_redraw()

func hide_intro() -> void:
	visible = false
	set_process(false)
	AudioManager.stop_intro_song()

func update_intro_state(entrance_cleared: bool, max_unlocked: int) -> void:
	if not entrance_cleared:
		if subtitle_label:
			subtitle_label.text = "⚠️ ENTRANCE TEST REQUIRED TO UNLOCK GAME"
		if play_btn:
			play_btn.text = "🎓 TAKE ENTRANCE TEST"
	else:
		if subtitle_label:
			subtitle_label.text = "Welcome Back! Level %d / 256 Unlocked" % max_unlocked
		if play_btn:
			play_btn.text = "▶ PLAY LEVEL %d" % max_unlocked

func _process(delta: float) -> void:
	if not is_visible_in_tree() or not visible:
		return

	anim_time += delta

	# Animated Title Bobbing & Glow
	if title_label:
		title_label.position.y = 35.0 + sin(anim_time * 2.5) * 6.0

	# Animated Hero Character Simulation
	hero_jump_timer += delta
	if hero_jump_timer >= 2.2:
		hero_jump_timer = 0.0
		hero_shocked = (randf() > 0.6)
	
	if hero_jump_timer < 0.6:
		# Jump upward and fall back
		var p = hero_jump_timer / 0.6
		hero_y_offset = -sin(p * PI) * 35.0
		hero_squash = Vector2(0.8, 1.25)
	else:
		hero_y_offset = 0.0
		hero_squash = hero_squash.move_toward(Vector2.ONE, delta * 6.0)

	# Blinking
	hero_blinking = (fmod(anim_time, 3.0) < 0.15)

	# Keyboard shortcuts to start (only active while intro is shown)
	if is_visible_in_tree() and visible and (Input.is_action_just_pressed("jump") or Input.is_key_pressed(KEY_ENTER)):
		_on_play_pressed()

	queue_redraw()

func _on_play_pressed() -> void:
	hide_intro()
	AudioManager.play_door()
	emit_signal("play_pressed")

func _on_select_pressed() -> void:
	hide_intro()
	emit_signal("level_select_pressed")

func _draw() -> void:
	if not is_visible_in_tree() or not visible:
		return

	# Draw animated floating decorative particles
	for i in range(18):
		var px = fmod(i * 47.0 + anim_time * 25.0, 800.0)
		var py = fmod(i * 31.0 + sin(anim_time + i) * 15.0 + 80.0, 420.0)
		var sz = 2.0 + sin(anim_time * 2.0 + i) * 1.5
		var alpha = 0.3 + 0.3 * sin(anim_time + i)
		draw_circle(Vector2(px, py), sz, Color(0.8, 0.4, 0.9, alpha))

	# Draw Animated Hero Mascot in Center
	var center_x: float = 400.0
	var center_y: float = 175.0 + hero_y_offset

	# Shadow
	var shadow_w: float = 30.0 * (1.0 - abs(hero_y_offset) / 60.0)
	_draw_shadow_oval(Vector2(center_x, 192.0), Vector2(shadow_w, 5.0), Color(0.0, 0.0, 0.0, 0.35))

	# Hero body
	var hw: float = 18.0 * hero_squash.x
	var hh: float = 19.0 * hero_squash.y
	var hero_rect: Rect2 = Rect2(center_x - hw, center_y - hh, hw * 2.0, hh * 2.0)
	draw_rect(hero_rect, Color(0.98, 0.80, 0.08), true)
	draw_rect(hero_rect, Color(0.85, 0.65, 0.05), false, 2.0)

	# Hero cute animated face
	if hero_shocked:
		# Wide O_O shocked eyes
		draw_circle(Vector2(center_x - 7.0, center_y - 3.0), 5.0, Color.WHITE)
		draw_circle(Vector2(center_x + 7.0, center_y - 3.0), 5.0, Color.WHITE)
		draw_circle(Vector2(center_x - 7.0, center_y - 3.0), 2.2, Color.BLACK)
		draw_circle(Vector2(center_x + 7.0, center_y - 3.0), 2.2, Color.BLACK)
		draw_circle(Vector2(center_x, center_y + 6.0), 3.0, Color(0.2, 0.1, 0.1))
	elif hero_blinking:
		draw_line(Vector2(center_x - 9.0, center_y - 3.0), Vector2(center_x - 3.0, center_y - 3.0), Color.BLACK, 2.0)
		draw_line(Vector2(center_x + 3.0, center_y - 3.0), Vector2(center_x + 9.0, center_y - 3.0), Color.BLACK, 2.0)
	else:
		draw_circle(Vector2(center_x - 6.0, center_y - 3.0), 4.0, Color.WHITE)
		draw_circle(Vector2(center_x + 6.0, center_y - 3.0), 4.0, Color.WHITE)
		draw_circle(Vector2(center_x - 5.0, center_y - 3.0), 2.0, Color.BLACK)
		draw_circle(Vector2(center_x + 7.0, center_y - 3.0), 2.0, Color.BLACK)

func _draw_shadow_oval(center: Vector2, radii: Vector2, color: Color) -> void:
	var points: PackedVector2Array = PackedVector2Array()
	var segments: int = 16
	for i in range(segments):
		var angle = (float(i) / float(segments)) * TAU
		points.append(center + Vector2(cos(angle) * radii.x, sin(angle) * radii.y))
	draw_colored_polygon(points, color)
