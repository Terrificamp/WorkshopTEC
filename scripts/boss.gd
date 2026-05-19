extends CharacterBody2D

@export var projetil_scene: PackedScene
var is_real = false
var can_attack = false
var projetil_direction 

func _ready() -> void:
	start_attack_loop()

func start_attack_loop() -> void:
	while true:
		await get_tree().create_timer(2).timeout
		_throw_projetil()

func _throw_projetil() -> void:
	#vazer aviso
	
	if !can_attack:
		return

	var projetil = projetil_scene.instantiate() as CharacterBody2D
	get_parent().add_child(projetil)
	projetil.global_position = global_position
	projetil._lanch(projetil_direction)

	var player = get_tree().get_first_node_in_group("boss")
	if player == null:
		return

	var direcao = (player.global_position - global_position).normalized()
	projetil.velocity = direcao * 300.0
