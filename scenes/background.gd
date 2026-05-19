# ParallaxBackground.gd
extends Node2D

@export var player: CharacterBody2D
@export var layers: Array[Node2D] = []
@export var layer_strengths: Array[float] = [0.02, 0.05, 0.1]

var base_positions: Array[Vector2] = []
var screen_center: Vector2

func _ready() -> void:
	screen_center = get_viewport().get_visible_rect().size / 2.0
	for layer in layers:
		base_positions.append(layer.position)

func _process(delta: float) -> void:
	if not player:
		return
	var offset = (player.global_position - screen_center)
	for i in layers.size():
		if i >= base_positions.size():
			break
		var target = base_positions[i] - offset * layer_strengths[i]
		layers[i].position = layers[i].position.lerp(target, delta * 5.0)
