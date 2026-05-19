extends CharacterBody2D
@onready var brilho =	$AnimatedSprite2D.material
@export var projetil_scene: PackedScene
var is_real = false
var can_attack = false
var projetil_direction 
var is_changing_fase = false
@onready var manager = $"../BossManager"


func _ready() -> void:
	start_attack_loop()
	# Reatribui o material duplicado ao sprite
	$AnimatedSprite2D.material = brilho.duplicate()
	brilho = $AnimatedSprite2D.material


func start_attack_loop() -> void:
	while true:
		await get_tree().create_timer(2).timeout
		_throw_projetil()


func _throw_projetil() -> void:
	#vazer aviso
	
	if !can_attack or !manager.is_alive:
		return

	$AnimatedSprite2D.play("preparing")
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
	

@onready var boss2Shader = $"../Boss2/AnimatedSprite2D".material

func _on_hurtbox_fase_1_area_entered(area: Area2D) -> void:
	if !is_real:
		return
	print(area.name)
	if area.is_in_group("PlayerProjectile"):
		Global.boss_life_1 -= 1.5
		brilho.set_shader_parameter("flash_amount", 0.5)
		await get_tree().create_timer(0.1).timeout 
		brilho.set_shader_parameter("flash_amount", 0)
	elif area.is_in_group("HitPlayer"):
		Global.boss_life_1 -= 1
		brilho.set_shader_parameter("flash_amount", 0.5)
		await get_tree().create_timer(0.1).timeout 
		brilho.set_shader_parameter("flash_amount", 0)
	manager._check_boss_life()
	print(Global.boss_life_1)

	
	
	pass # Replace with function body.
