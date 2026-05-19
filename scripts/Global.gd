extends Node
@onready var jenkinshp = 5
@onready var speciallevel = 100
var direction_projetil_boss1 = -1
var direction_projetil_boss2 = 1
signal take_damege_player
signal take_damege_boss

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not speciallevel >= 99:
		speciallevel = speciallevel + 0.1
	pass
