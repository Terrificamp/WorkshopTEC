extends ColorRect
func _physics_process(delta: float) -> void:
	_update_damage_overlay()
func _update_damage_overlay() -> void:
	var hp_ratio = clamp(Global.jenkinshp / 5.0, 0.0, 1.0)
	$".".color = Color(1, 0, 0, (1.0 - hp_ratio) * 0.6)
