
# bomb.gd
extends RigidBody2D

var explosion_radius = randi_range(60, 120)
var camera: Node
var shader_mat: ShaderMaterial

func _ready() -> void:
	linear_velocity.x += randf_range(100,-100)
	camera = get_tree().get_first_node_in_group("MainCamera")
	shader_mat = $AnimatedSprite2D.material  # or $Sprite2D.material, whatever your bomb visual is
	_flash_loop()
	await get_tree().create_timer(3.0).timeout
	explode()

func _flash_loop() -> void:
	# flashes slowly at first, then faster as it gets closer to exploding
	var intervals = [0.5, 0.5, 0.4, 0.4, 0.3, 0.3, 0.2, 0.2, 0.1, 0.1, 0.05, 0.05]
	for interval in intervals:
		if not is_instance_valid(self):
			return
		_set_flash(1.0)
		await get_tree().create_timer(interval * 0.3).timeout
		if not is_instance_valid(self):
			return
		_set_flash(0.0)
		await get_tree().create_timer(interval * 0.7).timeout

func _set_flash(amount: float) -> void:
	if shader_mat:
		shader_mat.set_shader_parameter("flash_amount", amount)

func explode() -> void:
	if not is_instance_valid(self):
		return

	# screenshake first, before anything else
	if camera:
		camera.shake(6, 2)

	# detach the audio player so it survives queue_free
	var audio = $AudioStreamPlayer2D
	remove_child(audio)
	get_parent().add_child(audio)
	audio.global_position = global_position
	audio.play()
	# auto-clean the audio node when it finishes
	audio.finished.connect(audio.queue_free)

	var players = get_tree().get_nodes_in_group("Player")
	for player in players:
		if player.global_position.distance_to(global_position) <= explosion_radius:
			Global.take_damege_player.emit(1)

	_spawn_blast_circle()
	queue_free()

func _spawn_blast_circle() -> void:
	# draws a circle using a simple Node2D with _draw
	var blast = Node2D.new()
	blast.global_position = global_position
	blast.z_index = z_index + 1
	get_parent().add_child(blast)

	# inner hot core
	var core = _make_circle_sprite(explosion_radius * 0.5, Color(1.0, 1.0, 0.8, 0.95))
	blast.add_child(core)

	# outer ring
	var ring = _make_circle_sprite(explosion_radius, Color(1.0, 0.4, 0.05, 0.75))
	blast.add_child(ring)

	# animate: scale up and fade out
	var tween = blast.create_tween()
	tween.set_parallel(true)
	tween.tween_property(blast, "scale", Vector2(1.6, 1.6), 0.35)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(blast, "modulate:a", 0.0, 0.35)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tween.finished
	blast.queue_free()

func _make_circle_sprite(radius: float, color: Color) -> Node2D:
	# builds a filled circle out of a canvas item using _draw
	var circle = Node2D.new()
	# store params so _draw can use them
	circle.set_meta("radius", radius)
	circle.set_meta("color", color)
	circle.connect("draw", func():
		circle.draw_circle(Vector2.ZERO, circle.get_meta("radius"), circle.get_meta("color"))
	)
	circle.queue_redraw()
	return circle
