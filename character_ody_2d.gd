extends CharacterBody2D
@onready var plr = $"../Jenkins"

var SPEED = 100.0
const JUMP_VELOCITY = -400.0
var direction: float
var Acting = false
func _physics_process(delta: float) -> void:
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		print(collider.name)
		if collider.name == "Jenkins":
			Acting = true
			$AnimatedSprite2D.play("Attack")
			$AnimatedSprite2D.speed_scale = 1
			await $AnimatedSprite2D.animation_finished
			Acting = false
	else:
		SPEED = 100
	if not is_on_floor():
		velocity += get_gravity() * delta
	if plr.position.x > position.x:
		direction = 1
	elif plr.position.x < position.x:
		direction = -1
	if Acting == false:
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = false
			$RayCast2D.target_position.x = 60
		if velocity.x < 0:
			$RayCast2D.target_position.x = -60
			$AnimatedSprite2D.flip_h = true
		if velocity.x != 0:
			$AnimatedSprite2D.play("Move")
			$AnimatedSprite2D.speed_scale = velocity.x / 70
		elif velocity.x == 0:
			$AnimatedSprite2D.play("Idle")
			$AnimatedSprite2D.speed_scale = 1
	else:
		SPEED = 0
	velocity.x = SPEED * direction
	move_and_slide()


func _on_hitbox_body_entered(body: Node2D) -> void:
	var collider = body
	print(collider.name)
	if collider.name == "Tomate":
		Acting = true
		$AnimatedSprite2D.play("Hit")
		$AnimatedSprite2D.speed_scale = 1
		await $AnimatedSprite2D.animation_finished
		Acting = false
