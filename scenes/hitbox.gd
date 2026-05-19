extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	$".".queue_free()
	pass # Replace with function body.
func dwnslam() -> void:
	$AnimatedSprite2D.queue_free()
func start(dir,mov) -> void:
	if dir == 1:
		$AnimatedSprite2D.flip_h = false
		position.x += 20
		if mov == true:
			position.x += 15
	if dir == -1:
		$AnimatedSprite2D.flip_h = true
		position.x -= 20
		if mov == true:
			position.x -= 15
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
