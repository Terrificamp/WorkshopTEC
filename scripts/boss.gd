extends CharacterBody2D

@export var projetil_scene: PackedScene
var is_real = false
var can_attack = false
var projetil_direction 



func _ready() -> void:
	start_attack_loop()
	


func start_attack_loop() -> void:
	while Global.phase == 1:
		await get_tree().create_timer(2).timeout
		_throw_projetil()
	while Global.phase == 2:
		await get_tree().create_timer(2).timeout
		_attack_phase1()
		

func _throw_projetil() -> void:
	#vazer aviso
	
	if !can_attack:
		$AnimatedSprite2D.play("idle_fase1")
		return

	$AnimatedSprite2D.play("preparing_fase1")
	await $AnimatedSprite2D.animation_finished
	
	var projetil = projetil_scene.instantiate() as CharacterBody2D
	get_parent().add_child(projetil)
	projetil.global_position = Vector2(global_position.x,global_position.y +30.0)

	
	print("teste 1 - global", projetil.global_position )
	print("teste 2 - position", projetil.position.y)
	projetil._lanch(projetil_direction)

	var player = get_tree().get_first_node_in_group("boss")
	if player == null:
		return

	var direcao = (player.global_position - global_position).normalized()
	projetil.velocity = direcao * 300.0
	
func _attack_phase1() -> void:
	pass
	
	
	
	
	
