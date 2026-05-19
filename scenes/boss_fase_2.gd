extends CharacterBody2D

@onready var brilho = $AnimatedSprite2D.material
var player
const ALTURA_ACIMA_PLAYER := -200.0
const ALTURA_SAIDA := -600.0
const VELOCIDADE_SEGUIR := 4.0
var seguindo := false
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return
	_entrada_tween()
func _process(delta: float) -> void:
	if seguindo and player:
		var alvo = Vector2(player.global_position.x, player.global_position.y + ALTURA_ACIMA_PLAYER)
		global_position = global_position.lerp(alvo, VELOCIDADE_SEGUIR * delta)
func _entrada_tween() -> void:
	seguindo = true
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position:y", ALTURA_SAIDA, 0.6)\
		.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position:y", player.global_position.y + ALTURA_ACIMA_PLAYER, 2)\
		.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)
	await tween.finished
	seguindo = true
	start_attack_loop()
func start_attack_loop() -> void:
	while true:
		await get_tree().create_timer(2.0).timeout
		await attack()  # espera o ataque terminar antes do próximo
		
func attack() -> void:
	seguindo = false

	var destino = Vector2(global_position.x, 612.5)
	print(player.global_position.y)

	# Desce até o jogador
	$AnimatedSprite2D.play("preparing")
	await $AnimatedSprite2D.animation_finished
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "global_position", destino, 0.2)\
		.set_trans(Tween.TRANS_SINE)
	$AnimatedSprite2D.play("attacking")
	await tween.finished


	$AnimatedSprite2D.play("smashed")
	await get_tree().create_timer(0.2).timeout

	# Volta para cima do jogador
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
	
	
	
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerProjectile"):
		Global.boss_life_2 -= 1.5
		print(Global.boss_life_2)
		brilho.set_shader_parameter("flash_amount", 0.5)
		await get_tree().create_timer(0.1).timeout
		brilho.set_shader_parameter("flash_amount", 0)
