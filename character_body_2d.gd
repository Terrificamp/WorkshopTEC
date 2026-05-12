extends CharacterBody2D
@onready var time = $AnimatedSprite2D/Timer

const SPEED = 200.0
const JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Pulo") and is_on_floor():
		time.start(0.5)
		print("erapapula????")
		if Input.is_action_just_released("Pulo") and not time.is_stopped():
			print("Pulomaisbaixo????")
			pass
			velocity.y = JUMP_VELOCITY
		if Input.is_action_just_released("Pulo") and time.is_stopped():
			print("Pulomaisalto????")
			pass
			velocity.y = JUMP_VELOCITY*2

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Direita","Esquerda")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x != 0:
		$AnimatedSprite2D.play("Walk")
		$AnimatedSprite2D.speed_scale = velocity.x / 50
	else :
		$AnimatedSprite2D.play("Idle")
		$AnimatedSprite2D.speed_scale = 1
	if velocity.y > 0:
		$AnimatedSprite2D.play("Jump")
	move_and_slide()


func _on_timer_timeout() -> void:
	pass # Replace with function body.
