extends RigidBody2D

var speed := 200.0
var trail: Line2D
var max_trail_points := 40

func _ready() -> void:
	trail = Line2D.new()
	trail.width = 6.0
	trail.default_color = Color(1.0, 1.0, 1.0, 0.8)
	trail.begin_cap_mode = Line2D.LINE_CAP_ROUND
	trail.end_cap_mode = Line2D.LINE_CAP_ROUND

	var gradient := Gradient.new()
	gradient.set_color(1, Color(1.0, 0.769, 0.765, 0.663))
	gradient.set_color(0, Color(0.645, 0.0, 0.233, 0.0))
	trail.gradient = gradient
	var curve := Curve.new()
	curve.add_point(Vector2(0.0, 0.0))  # tail: width 0
	curve.add_point(Vector2(1.0, 1.0))  # front: full width
	trail.width_curve = curve

	get_tree().current_scene.add_child(trail)

func launch(direction: Vector2, playerspeed: Variant) -> void:
	linear_velocity = direction * speed + playerspeed
	linear_velocity.y = -350

func _process(delta: float) -> void:
	trail.add_point(global_position)
	if trail.get_point_count() > max_trail_points:
		trail.remove_point(0)

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	print("Hit object: ", body.name)
	$".".freeze = true
	$".".sleeping = true
	$AnimatedSprite2D.play("Pop")
	$AnimatedSprite2D/Timer.start(1)
	$AnimationPlayer.play("Despawn")
	await $AnimatedSprite2D/Timer.timeout
	print("Despawn")
	$".".queue_free()

func _exit_tree() -> void:
	if trail:
		trail.queue_free()
