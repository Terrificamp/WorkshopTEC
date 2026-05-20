extends Node
@onready var jenkinshp = 5
@onready var speciallevel = 100
var direction_projetil_boss1 = -1
var direction_projetil_boss2 = 1
signal take_damege_player
signal take_damage_boss1
signal take_damage_boss2
signal boss_damaged(amount: int)
var boss_life_1 = 40
var boss_life_2 = 100
var boss_life_3 = 160


func reset() -> void:
	boss_life_1 = 40
	boss_life_2 = 100
	jenkinshp = 5
	speciallevel = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not speciallevel >= 99:
		speciallevel = speciallevel + 0.1
	pass
