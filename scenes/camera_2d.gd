extends Camera2D

var shake_amount: float = 0.0
var shake_duration: float = 0.0
var shake_timer: float = 0.0

func shake(amount: float, duration: float) -> void:
	shake_amount = amount
	shake_duration = duration
	shake_timer = duration

func _process(delta: float) -> void:
	if shake_timer > 0.0:
		shake_timer -= delta
		# Ease out the shake as time runs out
		var strength = shake_amount * (shake_timer / shake_duration)
		offset = Vector2(
			randf_range(-strength, strength),
			randf_range(-strength, strength)
		)
	else:
		offset = Vector2.ZERO
