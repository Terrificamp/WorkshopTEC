extends CharacterBody2D
@onready var brilho =	$AnimatedSprite2D.material
@export var projetil_scene: PackedScene
var is_real = false
var can_attack = false
var projetil_direction 



func _ready() -> void:
	start_attack_loop()
	brilho.duplicate()


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
	projetil.global_position = Vector2(global_position.x,global_position.y +20.0)

	
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
	
	
	
	
	



func _on_hurtbox_fase_2_area_entered(area: Area2D) -> void:
	if !is_real:
		if area.is_in_group("PlayerProjectile"):
			brilho.set_shader_parameter("flash_amount", 0.5)
			await get_tree().create_timer(0.1).timeout 
			brilho.set_shader_parameter("flash_amount", 0)
		elif area.is_in_group("HitPlayer"):
			brilho.set_shader_parameter("flash_amount", 0.5)
			await get_tree().create_timer(0.1).timeout 
			brilho.set_shader_parameter("flash_amount", 0)
		return
	print(area.name)
	if area.is_in_group("PlayerProjectile"):
		Global.boss_life -= 1.5
		brilho.set_shader_parameter("flash_amount", 0.5)
		await get_tree().create_timer(0.1).timeout 
		brilho.set_shader_parameter("flash_amount", 0)
	elif area.is_in_group("HitPlayer"):
		Global.boss_life -= 1
		brilho.set_shader_parameter("flash_amount", 0.5)
		await get_tree().create_timer(0.1).timeout 
		brilho.set_shader_parameter("flash_amount", 0)
	if Global.boss_life >= 65:
		Global.phase = 1
	elif Global.boss_life >= 40:
		Global.phase = 2	
	elif Global.boss_life >= 20:
		Global.phase = 3
		print(Global.boss_life)
	pass # Replace with function body.
