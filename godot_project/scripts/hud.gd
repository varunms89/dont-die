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

	populate_level_grid(256)

func update_hud(title: String, subtitle: String, deaths: int, hint: String) -> void:
	if title_label:
		title_label.text = title + " — " + subtitle
	if deaths_label:
		deaths_label.text = "💀 " + str(deaths)
	current_hint_text = hint
	if hint_banner and hint_banner.visible and hint_label:
		hint_label.text = current_hint_text

func populate_level_grid(total_levels: int) -> void:
	if level_grid == null:
		return
	for child in level_grid.get_children():
		child.queue_free()

	for i in range(1, total_levels + 1):
		var btn = Button.new()
		btn.text = str(i)
		btn.custom_minimum_size = Vector2(44, 36)
		btn.pressed.connect(_on_select_level.bind(i - 1))
		level_grid.add_child(btn)

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
