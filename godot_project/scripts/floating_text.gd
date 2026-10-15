extends Node2D

@onready var label: Label = $Label

var text: String = "LOL! 😈"
var color: Color = Color(1.0, 0.8, 0.2, 1.0)
var velocity_y: float = -35.0
var lifetime: float = 1.8
var current_time: float = 0.0

func _ready() -> void:
	if label:
		label.text = text
		label.modulate = color

func setup(p_text: String, p_color: Color = Color(1.0, 0.8, 0.2, 1.0)) -> void:
	text = p_text
	color = p_color
	if label:
		label.text = text
		label.modulate = color

func _process(delta: float) -> void:
	position.y += velocity_y * delta
	current_time += delta
	var alpha: float = clamp(1.0 - (current_time / lifetime), 0.0, 1.0)
	modulate.a = alpha
	if current_time >= lifetime:
		queue_free()
