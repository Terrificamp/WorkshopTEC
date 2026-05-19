extends CharacterBody2D
class_name Player
@onready var time = $AnimatedSprite2D/Timer
@export var tomato_scene: PackedScene
@export var hitbox_scene: PackedScene
@export var throw_interval := 0.6 
@export var damage_marker_scene: PackedScene
@onready var camera: Camera2D = $"../Camera2D"
@onready var health = Global.jenkinshp
var throw_cooldown := 0.0
var SPEED = 150.0
const JUMP_VELOCITY = -350.0
var doing_action := false
var facing_direction := 1
var dying = false
var dashing = false
var onfloor = false
var moving = false
signal touchingfloor
func _ready() -> void:
	Global.take_damege_player.connect(take_damage)
	Global.jenkinshp = 5
func _physics_process(delta: float) -> void:
	if velocity.x != 0 :
		moving = true
	if is_on_floor():
		onfloor = true
		touchingfloor.emit()
	else:
		onfloor = false
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("Pulo") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$Jump.pitch_scale = 1
		$Jump.play()
	if Input.is_action_just_released("Pulo") and velocity.y < 0 and not is_on_floor():
		$Jump.pitch_scale = 1.5
		velocity.y *= 0
	var direction := Input.get_axis("Direita", "Esquerda")
	if not dashing:
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
	if dashing == true:
		$Area2D/hurtbox.disabled = true
	else:
		$Area2D/hurtbox.disabled = false
	if throw_cooldown > 0.0:
		throw_cooldown -= delta
	if Input.is_action_pressed("Tomate") and throw_cooldown <= 0.0 and not doing_action:
		$Throw.pitch_scale = randf_range(0.9, 1.3)
		$Throw.play()
		_throw_tomato()
	if Input.is_action_just_pressed("Dash") and doing_action == false:
		_do_dash()
	if Input.is_action_pressed("Ataque") and doing_action == false:
		Ataque()
func take_damage(amount: int) -> void:
	if dying == false:
		doing_action = false
		$AnimatedSprite2D.play("Hit")
		camera.shake(8.0, 0.3)
		Global.jenkinshp = Global.jenkinshp - amount
		if Global.jenkinshp <= 0:
			dying = true
			doing_action = true
			SPEED = 0
			$AnimatedSprite2D.play("Dying")
			await $AnimatedSprite2D.animation_finished
			$"../ColorRect/AnimationPlayer".play("Endgame")
			await $"../ColorRect/AnimationPlayer".animation_finished
			get_tree().reload_current_scene()
		else:
			spawn_damage_marker(amount)
func spawn_damage_marker(scale) -> void:
	var marker = damage_marker_scene.instantiate()
	camera.add_child(marker)
	var viewport_rect = get_viewport().get_visible_rect()
	var half_w = (viewport_rect.size.x / 2.0) / camera.zoom.x
	var half_h = (viewport_rect.size.y / 2.0) / camera.zoom.y
	marker.position = Vector2(
		randf_range(-half_w, half_w),
		randf_range(-half_h, half_h)
	)
	var s = clamp(scale * 0.2, 1, 6)
	marker.scale = Vector2(s, s)
func _do_dash() -> void:
	if Global.speciallevel <= 35:
		return
	Global.speciallevel -= 35
	dashing = true
	$CPUParticles2D.direction.x = facing_direction*-1
	$CPUParticles2D.emitting = true
	$Dash.play()
	$AnimatedSprite2D.play("Dash")
	var dash_velocity = facing_direction * 600.0
	velocity.x = dash_velocity
	$Dash2.start(0.2)
	await $Dash2.timeout
	velocity.x = 0
	dashing = false
func _throw_tomato() -> void:
	if Global.speciallevel <= 10:
		return
	Global.speciallevel -= 10
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
func Ataque() -> void:
	if velocity.x != 0 and velocity.y == 0 and doing_action == false:
			doing_action = true
			var ataque = hitbox_scene.instantiate() as Area2D
			var attackpoint: CharacterBody2D = $"."
			ataque.global_position = attackpoint.global_position
			var throw_dir := Vector2(facing_direction, -0.2).normalized()
			ataque.start(facing_direction,moving)
			get_tree().current_scene.add_child(ataque)
			$Swing.pitch_scale = randf_range(1.5, 2.0)
			$Swing.play()
			$AnimatedSprite2D.speed_scale = 1
			$AnimatedSprite2D.play("AttackWalk")
			await $AnimatedSprite2D.animation_finished
			doing_action = false
			$AnimatedSprite2D.speed_scale = 0
	elif not velocity.x != 0 and velocity.y == 0 and doing_action == false:
			doing_action = true
			var ataque = hitbox_scene.instantiate() as Area2D
			var attackpoint: CharacterBody2D = $"."
			ataque.global_position = attackpoint.global_position
			var throw_dir := Vector2(facing_direction, -0.2).normalized()
			ataque.start(facing_direction,moving)
			get_tree().current_scene.add_child(ataque)
			$Swing.pitch_scale = randf_range(1.5, 2.0)
			$Swing.play()
			$AnimatedSprite2D.speed_scale = 1
			$AnimatedSprite2D.play("Attack")
			await $AnimatedSprite2D.animation_finished
			doing_action = false
			$AnimatedSprite2D.speed_scale = 0
	if velocity.y != 0 and doing_action == false:
			velocity.y =+ 400
			doing_action = true
			$Swing.pitch_scale = randf_range(1.5, 2.0)
			$Swing.play()
			$AnimatedSprite2D.speed_scale = 1
			$AnimatedSprite2D.play("AttackDwn")
			await touchingfloor
			doing_action = true
			var ataque = hitbox_scene.instantiate() as Area2D
			var attackpoint: CharacterBody2D = $"."
			ataque.global_position = attackpoint.global_position
			var throw_dir := Vector2(facing_direction, -0.2).normalized()
			ataque.dwnslam()
			get_tree().current_scene.add_child(ataque)
			$CrashDwn.emitting = true
			doing_action = false
			$AnimatedSprite2D.speed_scale = 0

func _on_timer_timeout() -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.is_in_group("Projectile"):
		Global.take_damege_player.emit(1)
