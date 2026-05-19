extends HBoxContainer
var empty = load("res://Coração vazio.png")
var full = load("res://Coração cheio.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		var hearts = [$Heart1, $Heart2, $Heart3, $Heart4, $Heart5]
		for i in hearts.size():
			hearts[i].texture = full if i < Global.jenkinshp else empty
	
