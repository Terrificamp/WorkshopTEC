extends CharacterBody2D

@onready var brilho = $AnimatedSprite2D.material
@onready var anim = $AnimatedSprite2D
@export var bomb_scene: PackedScene

var player

const ALTURA_ACIMA_PLAYER := -200.0
const ALTURA_SAIDA := -600.0
const VELOCIDADE_SEGUIR := 4.0

const TRAIL_INTERVALO := 0.05
const TRAIL_DURACAO := 0.3
const TRAIL_OPACIDADE := 0.4

var dash_duration := 0.6
var seguindo := false
var morto := false
var attacking := false
var trail_ativo := false
var iframe := false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return
	_entrada_tween()

func _process(delta: float) -> void:
	if seguindo and player and not morto and not attacking:
		var alvo = Vector2(player.global_position.x, player.global_position.y + ALTURA_ACIMA_PLAYER)
		global_position = global_position.lerp(alvo, VELOCIDADE_SEGUIR * delta)

func _entrada_tween() -> void:
	seguindo = false
	trail_ativo = true
	_loop_trail()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position:y", ALTURA_SAIDA, 0.6)\
		.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position:y", player.global_position.y + ALTURA_ACIMA_PLAYER, 2)\
		.set_trans(Tween.TRANS_SPRING)\
		.set_ease(Tween.EASE_OUT)
	await tween.finished
	trail_ativo = false
	seguindo = true
	start_attack_loop()

func _loop_trail() -> void:
	while trail_ativo and not morto:
		_spawn_ghost()
		await get_tree().create_timer(TRAIL_INTERVALO).timeout

func _spawn_ghost() -> void:
	var ghost = Sprite2D.new()
	ghost.texture = anim.sprite_frames.get_frame_texture(anim.animation, anim.frame)
	ghost.flip_h = anim.flip_h
	ghost.scale = scale
	ghost.global_position = global_position
	ghost.z_index = z_index - 1
	ghost.modulate = Color(1.0, 1.0, 1.0, TRAIL_OPACIDADE)
	get_parent().add_child(ghost)
	var tween = create_tween()
	tween.tween_property(ghost, "modulate:a", 0.0, TRAIL_DURACAO)
	await tween.finished
	ghost.queue_free()

func start_attack_loop() -> void:
	while true:
		await get_tree().create_timer(2.0).timeout
		if morto or attacking:
			continue
		var roll = randi() % 3
		if roll == 0:
			await attack()
		elif roll == 1:
			await attack_dash_bombs()
		else:
			await attack_swoop()
		await check_hp()

func check_hp() -> void:
	if Global.boss_life_2 <= 0 and not morto:
		morto = true
		seguindo = false
		await _animacao_morte()

func _animacao_morte() -> void:
	$hurt_box.monitoring = false
	if anim.sprite_frames.has_animation("morte"):
		anim.play("morte")
	trail_ativo = true
	_loop_trail()
	var camera = get_viewport().get_camera_2d()
	var centro_tela: Vector2
	if camera:
		centro_tela = camera.global_position
	else:
		centro_tela = get_viewport_rect().size / 2
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", centro_tela, 1.0)
	tween.parallel().tween_property(self, "scale", Vector2(0.7, 0.7), 1.0)
	tween.parallel().tween_property(anim, "modulate", Color(0.3, 0.3, 0.3), 1.0)
	tween.tween_interval(0.5)
	var fora_da_tela_y = get_viewport_rect().size.y + 300.0
	tween.tween_property(self, "global_position:y", fora_da_tela_y, 1.2)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "scale", Vector2(0.3, 0.3), 1.2)
	tween.parallel().tween_property(anim, "modulate", Color(0.0, 0.0, 0.0), 1.2)
	await tween.finished
	trail_ativo = false
	$"../ColorRect/AnimationPlayer".play("Endgame")
	await $"../ColorRect/AnimationPlayer".animation_finished
	$"../Camera2D/Control/VBoxContainer/Label".show_score()
	queue_free()

func attack() -> void:
	attacking = true
	seguindo = false
	var destino = Vector2(global_position.x, 612.5)
	$AnimatedSprite2D.play("preparing")
	await $AnimatedSprite2D.animation_finished
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "global_position", destino, 0.2)\
		.set_trans(Tween.TRANS_SINE)
	$AnimatedSprite2D.play("attacking")
	await tween.finished
	$AnimatedSprite2D.play("smashed")
	$CPUParticles2D.emitting = true
	$AudioStreamPlayer2D.play()
	$"../Camera2D".shake(5, 1)
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.play("coming_back")
	await $AnimatedSprite2D.animation_finished
	var volta = Vector2(player.global_position.x, player.global_position.y + ALTURA_ACIMA_PLAYER)
	var tween2 = create_tween()
	tween2.set_ease(Tween.EASE_OUT)
	tween2.tween_property(self, "global_position", volta, 0.6)\
		.set_trans(Tween.TRANS_BOUNCE)
	await tween2.finished
	$AnimatedSprite2D.play("idle")
	seguindo = true
	attacking = false

func attack_dash_bombs() -> void:
	attacking = true
	seguindo = false
	trail_ativo = true
	_loop_trail()

	var start_x = -200.0
	var dash_y = global_position.y
	var end_x = get_viewport_rect().size.x + 200.0
	var screen_w = get_viewport_rect().size.x

	global_position = Vector2(start_x, dash_y)
	anim.flip_h = false
	$AnimatedSprite2D.play("preparing")
	await $AnimatedSprite2D.animation_finished

	var bomb_data: Array = []
	for i in range(5):
		var bomb_x = screen_w * (i + 1) / 6.0
		var ratio = (bomb_x - start_x) / (end_x - start_x)
		bomb_data.append({ "x": bomb_x, "delay": dash_duration * ratio })

	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position:x", end_x, dash_duration)\
		.set_trans(Tween.TRANS_SINE)

	var dash_start_time = Time.get_ticks_msec()
	for data in bomb_data:
		_drop_bomb_after(data.delay, data.x, dash_y, dash_start_time)

	await tween.finished
	trail_ativo = false

	var volta = Vector2(player.global_position.x, player.global_position.y + ALTURA_ACIMA_PLAYER)
	var tween2 = create_tween()
	tween2.set_ease(Tween.EASE_OUT)
	tween2.tween_property(self, "global_position", volta, 0.5)\
		.set_trans(Tween.TRANS_SINE)
	await tween2.finished
	$AnimatedSprite2D.play("idle")
	anim.flip_h = true
	seguindo = true
	attacking = false

func _drop_bomb_after(delay: float, bomb_x: float, bomb_y: float, dash_start_time: int) -> void:
	await get_tree().create_timer(delay).timeout
	if not attacking or morto:
		return
	var elapsed = (Time.get_ticks_msec() - dash_start_time) / 1000.0
	if elapsed > dash_duration + 0.05:
		return
	if bomb_scene:
		var bomb = bomb_scene.instantiate()
		bomb.global_position = Vector2(bomb_x, bomb_y)
		get_parent().add_child(bomb)

func attack_swoop() -> void:
	attacking = true
	seguindo = false
	trail_ativo = true
	_loop_trail()

	var screen_w = get_viewport_rect().size.x
	var swoop_y = player.global_position.y

	var start_pos = Vector2(-250.0, swoop_y)
	var tween_entry = create_tween()
	tween_entry.set_ease(Tween.EASE_IN_OUT)
	tween_entry.tween_property(self, "global_position", start_pos, 0.5)\
		.set_trans(Tween.TRANS_SINE)
	await tween_entry.finished

	anim.flip_h = false
	$AnimatedSprite2D.play("preparing")
	await get_tree().create_timer(0.8).timeout

	$AnimatedSprite2D.play("attacking")
	$Drag.emitting = true
	var end_pos = Vector2(screen_w + 250.0, swoop_y)
	var tween_swoop = create_tween()
	tween_swoop.set_ease(Tween.EASE_IN_OUT)
	tween_swoop.set_trans(Tween.TRANS_SINE)
	tween_swoop.tween_property(self, "global_position", end_pos, 2.4)
	await tween_swoop.finished
	$Drag.emitting = false
	$CPUParticles2D.emitting = true
	$"../Camera2D".shake(4, 0.3)

	$AnimatedSprite2D.play("coming_back")
	await $AnimatedSprite2D.animation_finished
	var volta = Vector2(player.global_position.x, player.global_position.y + ALTURA_ACIMA_PLAYER)
	var tween_return = create_tween()
	tween_return.set_ease(Tween.EASE_OUT)
	tween_return.tween_property(self, "global_position", volta, 0.6)\
		.set_trans(Tween.TRANS_BOUNCE)
	await tween_return.finished

	trail_ativo = false
	$AnimatedSprite2D.play("idle")
	anim.flip_h = true
	seguindo = true
	attacking = false

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerProjectile") and not iframe and not morto:
		iframe = true
		Global.boss_damaged.emit(1)
		Global.boss_life_2 -= 1
		brilho.set_shader_parameter("flash_amount", 0.5)
		await get_tree().create_timer(0.1).timeout
		brilho.set_shader_parameter("flash_amount", 0)
		await get_tree().create_timer(0.01).timeout
		print(Global.boss_life_2)
		iframe = false
	elif area.is_in_group("HitPlayer") and not iframe and not morto:
		iframe = true
		Global.boss_damaged.emit(1)
		Global.boss_life_2 -= 1
		brilho.set_shader_parameter("flash_amount", 0.5)
		await get_tree().create_timer(0.1).timeout
		brilho.set_shader_parameter("flash_amount", 0)
		await get_tree().create_timer(0.01).timeout
		print(Global.boss_life_2)
		iframe = false
