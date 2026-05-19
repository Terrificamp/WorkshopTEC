extends CharacterBody2D

@onready var brilho = $AnimatedSprite2D.material
@onready var anim = $AnimatedSprite2D
var player

const ALTURA_ACIMA_PLAYER := -200.0
const ALTURA_SAIDA := -600.0
const VELOCIDADE_SEGUIR := 4.0
var seguindo := false
var morto := false
var trail_ativo := false
const TRAIL_INTERVALO := 0.05  # how often a ghost spawns (seconds)
const TRAIL_DURACAO := 0.3     # how long each ghost lasts
const TRAIL_OPACIDADE := 0.4   # starting opacity of each ghost

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return
	_entrada_tween()

func _process(delta: float) -> void:
	if seguindo and player and not morto:
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
	seguindo = true
	start_attack_loop()

func start_attack_loop() -> void:
	while true:
		await get_tree().create_timer(2.0).timeout
		check_hp()
func _loop_trail() -> void:
	while trail_ativo and not morto:
		_spawn_ghost()
		await get_tree().create_timer(TRAIL_INTERVALO).timeout

func _spawn_ghost() -> void:
	var ghost = Sprite2D.new()
	ghost.texture = anim.sprite_frames.get_frame_texture(
		anim.animation, anim.frame
	)
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
func check_hp() -> void:
	if Global.boss_life_2 <= 0 and not morto:
		morto = true
		seguindo = false
		_animacao_morte()

func _animacao_morte() -> void:
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
	queue_free()
var iframe := false
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerProjectile") and not iframe and not morto:
		iframe = true
		Global.boss_life_2 -= 1
		brilho.set_shader_parameter("flash_amount", 0.5)
		await get_tree().create_timer(0.1).timeout
		brilho.set_shader_parameter("flash_amount", 0)
		await get_tree().create_timer(0.1).timeout
		print(Global.boss_life_2)
		iframe = false
