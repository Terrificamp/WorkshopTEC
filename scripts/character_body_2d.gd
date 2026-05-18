extends CharacterBody2D
class_name Player
@onready var time = $AnimatedSprite2D/Timer
@export var tomato_scene: PackedScene
@export var throw_interval := 0.6 
var throw_cooldown := 0.0
const SPEED = 150.0
const JUMP_VELOCITY = -350.0
var doing_action := false
var facing_direction := 1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Pulo") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("Pulo") and velocity.y < 0 and not is_on_floor():
		velocity.y *= 0

	var direction := Input.get_axis("Direita", "Esquerda")
	if direction != 0:
		facing_direction = int(sign(direction))
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true

	if not doing_action:
		if velocity.y != 0:
			$AnimatedSprite2D.play("Jump")
		elif velocity.x != 0 and velocity.y == 0:
			$AnimatedSprite2D.play("Walk")
			$AnimatedSprite2D.speed_scale = velocity.x / 50
		elif velocity.x == 0 and velocity.y == 0:
			$AnimatedSprite2D.play("Idle")
			$AnimatedSprite2D.speed_scale = 1

	move_and_slide()

	if throw_cooldown > 0.0:
		throw_cooldown -= delta
	if Input.is_action_pressed("ui_accept") and throw_cooldown <= 0.0 and not doing_action:
		_throw_tomato()

func _throw_tomato() -> void:
	doing_action = true
	$AnimatedSprite2D.speed_scale = 1
	$AnimatedSprite2D.play("ThrowTomato")
	var tomato = tomato_scene.instantiate() as RigidBody2D
	var throw_point: Marker2D = $ThrowPoint
	tomato.global_position = throw_point.global_position
	var throw_dir := Vector2(facing_direction, -0.2).normalized()
	get_tree().current_scene.add_child(tomato)
	tomato.launch(throw_dir, velocity)
	await $AnimatedSprite2D.animation_finished
	doing_action = false

func _on_timer_timeout() -> void:
	pass
