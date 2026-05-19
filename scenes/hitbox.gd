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


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Boss"):
		$AudioStreamPlayer2D.pitch_scale = randf_range(2.28,3.66)
		$AudioStreamPlayer2D.play()
		if Global.speciallevel <= 99:
			Global.speciallevel += 2
	pass # Replace with function body.
