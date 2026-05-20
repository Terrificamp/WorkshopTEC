
extends Node

@export var title: Control
@export var play_button: Control
@export var background: TextureRect
@export var bg_strength := 5.0
@export var title_strength := 15.0
@export var button_strength := 10.0

var screen_center := Vector2.ZERO
var base_title_pos := Vector2.ZERO
var base_button_pos := Vector2.ZERO
var base_bg_pos := Vector2.ZERO

func _ready() -> void:
	screen_center = get_viewport().get_visible_rect().size / 2
	base_title_pos = title.position
	base_button_pos = play_button.position
	base_bg_pos = background.position

func _process(delta: float) -> void:
	var mouse = get_viewport().get_mouse_position()
	var offset = (mouse - screen_center) / screen_center
	title.position = title.position.lerp(
		base_title_pos + offset * title_strength, 6.0 * delta
	)
	play_button.position = play_button.position.lerp(
		base_button_pos + offset * button_strength, 6.0 * delta
	)
	background.position = background.position.lerp(
		base_bg_pos + offset * bg_strength, 6.0 * delta
	)
