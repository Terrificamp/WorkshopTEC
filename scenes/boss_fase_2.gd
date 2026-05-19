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
		push_error("Boss: jogador não encontrado! Adicione o jogador ao grupo 'Player'.")
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
		pass
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerProjectile"):
		Global.boss_life_1 -= 1.5
		brilho.set_shader_parameter("flash_amount", 0.5)
		await get_tree().create_timer(0.1).timeout
		brilho.set_shader_parameter("flash_amount", 0)
