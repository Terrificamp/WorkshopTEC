# score.gd
extends Label

var total_damage := 0
var points := 0

func _ready() -> void:
	Global.take_damege_player  # just ensuring Global is accessible
	# connect to a signal that fires whenever the boss takes damage
	# add this signal to your Global.gd: signal boss_damaged
	Global.boss_damaged.connect(_on_boss_damaged)
	$"..".visible = false  # hidden during gameplay, shown at end

func _on_boss_damaged(amount: int) -> void:
	total_damage += amount

func show_score() -> void:
	# convert damage to points however you like
	$"..".visible = true
	points = total_damage * 10
	text = "0"
	
	# count up animation
	var tween = create_tween()
	tween.tween_method(_update_label, 0, points, 2.0)\
		.set_trans(Tween.TRANS_EXPO)\
		.set_ease(Tween.EASE_OUT)

func _update_label(value: int) -> void:
	text = "Score: %d" % value
