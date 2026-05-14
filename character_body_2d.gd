extends CharacterBody2D
@onready var time = $AnimatedSprite2D/Timer

const SPEED = 150.0
const JUMP_VELOCITY = -350.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("Pulo") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("Pulo") and velocity.y < 0 and not is_on_floor():
		velocity.y *= 0
	var direction := Input.get_axis("Direita","Esquerda")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x != 0 and velocity.y == 0:
		$AnimatedSprite2D.play("Walk")
		$AnimatedSprite2D.speed_scale = velocity.x / 50
	else :
		$AnimatedSprite2D.play("Idle")
		$AnimatedSprite2D.speed_scale = 1
	if velocity.y > 0:
		$AnimatedSprite2D.play("Jump")
	move_and_slide()
	if Input.is_action_just_pressed("ui_accept"):
		print("JOGAOTOMATEEE")


func _on_timer_timeout() -> void:
	pass # Replace with function body.
