extends CanvasLayer

signal restart_requested()
signal level_selected(level_index: int)
signal mute_toggled()
signal menu_requested()

@onready var title_label: Label = $TopBar/TitleLabel
@onready var deaths_label: Label = $TopBar/DeathsLabel
@onready var hint_label: Label = $HintBanner/HintLabel
@onready var hint_banner: PanelContainer = $HintBanner
@onready var level_select_modal: PanelContainer = $LevelSelectModal
@onready var level_grid: GridContainer = $LevelSelectModal/VBox/Scroll/LevelGrid
@onready var menu_button: Button = $TopBar/RightButtons/MenuButton
@onready var restart_button: Button = $TopBar/RightButtons/RestartButton
@onready var hint_button: Button = $TopBar/RightButtons/HintButton
@onready var levels_button: Button = $TopBar/RightButtons/LevelsButton
@onready var mute_button: Button = $TopBar/RightButtons/MuteButton

# Mobile touch buttons
@onready var btn_left: TouchScreenButton = $MobileControls/BtnLeft
@onready var btn_right: TouchScreenButton = $MobileControls/BtnRight
@onready var btn_jump: TouchScreenButton = $MobileControls/BtnJump

var current_hint_text: String = ""

func _ready() -> void:
	if menu_button:
		menu_button.pressed.connect(_on_menu_pressed)
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)
	if hint_button:
		hint_button.pressed.connect(_on_hint_pressed)
	if levels_button:
		levels_button.pressed.connect(_on_levels_pressed)
	if mute_button:
		mute_button.pressed.connect(_on_mute_pressed)

	if hint_banner:
		hint_banner.visible = false
	if level_select_modal:
		level_select_modal.visible = false

	# Check if touch is supported or mobile
	if $MobileControls:
		$MobileControls.visible = DisplayServer.is_touchscreen_available() or OS.has_feature("mobile")

	populate_level_grid(256, 0, false)

func update_hud(title: String, subtitle: String, deaths: int, hint: String) -> void:
	if title_label:
		title_label.text = title + " — " + subtitle
	if deaths_label:
		deaths_label.text = "💀 " + str(deaths)
	current_hint_text = hint
	if hint_banner and hint_banner.visible and hint_label:
		hint_label.text = current_hint_text

var entrance_button: Button = null

func populate_level_grid(total_levels: int = 256, max_unlocked: int = 0, entrance_cleared: bool = false) -> void:
	if level_grid == null:
		return

	# Setup Entrance Test button in VBox above Scroll if not present
	var vbox = level_select_modal.get_node_or_null("VBox") if level_select_modal else null
	if vbox and entrance_button == null:
		entrance_button = Button.new()
		entrance_button.custom_minimum_size = Vector2(0, 42)
		entrance_button.add_theme_font_size_override("font_size", 15)
		vbox.add_child(entrance_button)
		vbox.move_child(entrance_button, 1)
		entrance_button.pressed.connect(func():
			if level_select_modal:
				level_select_modal.visible = false
			emit_signal("level_selected", 0)
		)

	if entrance_button:
		if entrance_cleared:
			entrance_button.text = "🎓 ENTRANCE TEST  [CLEARED ★]"
			entrance_button.modulate = Color(0.4, 1.0, 0.5)
		else:
			entrance_button.text = "🎓 ENTRANCE TEST  [REQUIRED ⚠️ - PASS TO UNLOCK]"
			entrance_button.modulate = Color(1.0, 0.85, 0.2)

	# Update header text
	var header = vbox.get_node_or_null("Header") as Label if vbox else null
	if header:
		if not entrance_cleared:
			header.text = "SELECT LEVEL — ⚠️ ENTRANCE TEST REQUIRED"
		else:
			header.text = "SELECT LEVEL (Unlocked: %d / %d)" % [min(max_unlocked, total_levels), total_levels]

	for child in level_grid.get_children():
		child.queue_free()

	for i in range(1, total_levels + 1):
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(44, 36)
		if entrance_cleared and i <= max_unlocked:
			btn.text = str(i)
			btn.modulate = Color(1.0, 1.0, 1.0, 1.0)
			btn.pressed.connect(_on_select_level.bind(i))
		else:
			btn.text = "🔒"
			btn.modulate = Color(0.45, 0.45, 0.55, 0.65)
			btn.pressed.connect(func():
				_on_locked_level_clicked(i, entrance_cleared)
			)
		level_grid.add_child(btn)

func _on_locked_level_clicked(level_num: int, entrance_cleared: bool) -> void:
	AudioManager.play_trap()
	var root = get_tree().current_scene
	if root and root.has_method("spawn_floating_text"):
		if not entrance_cleared:
			root.spawn_floating_text("🔒 LOCKED! Clear the Entrance Test first! 🎓", Vector2(400, 200), Color(1.0, 0.35, 0.35))
		else:
			root.spawn_floating_text("🔒 LOCKED! Clear Level %d first!" % (level_num - 1), Vector2(400, 200), Color(1.0, 0.35, 0.35))

func _on_restart_pressed() -> void:
	emit_signal("restart_requested")

func _on_hint_pressed() -> void:
	if hint_banner:
		hint_banner.visible = !hint_banner.visible
		if hint_banner.visible and hint_label:
			hint_label.text = current_hint_text

func _on_levels_pressed() -> void:
	if level_select_modal:
		level_select_modal.visible = !level_select_modal.visible

func _on_select_level(idx: int) -> void:
	if level_select_modal:
		level_select_modal.visible = false
	emit_signal("level_selected", idx)

func _on_menu_pressed() -> void:
	emit_signal("menu_requested")

func _on_mute_pressed() -> void:
	var muted = AudioManager.toggle_mute()
	if mute_button:
		mute_button.text = "🔇" if muted else "🔊"
	emit_signal("mute_toggled")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if level_select_modal and level_select_modal.visible:
			level_select_modal.visible = false
			get_viewport().set_input_as_handled()
		elif hint_banner and hint_banner.visible:
			hint_banner.visible = false
			get_viewport().set_input_as_handled()
