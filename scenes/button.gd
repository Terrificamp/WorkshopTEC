# restart_button.gd
extends Button

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	Global.reset()
	get_tree().reload_current_scene()

func _reset_global() -> void:
	Global.boss_life_1 = 50
	Global.boss_life_2 = 100
	Global.jenkinshp = 5
	Global.speciallevel = 100
