extends Node2D

@onready var boss1 = $"../Boss1"
@onready var boss2 = $"../Boss2"
@onready var boss1Anime = $"../Boss1/AnimatedSprite2D"
@onready var boss2Anime = $"../Boss2/AnimatedSprite2D"



func _ready():
	boss1.is_real = false
	boss1.can_attack = false
	boss1.projetil_direction = Global.direction_projetil_boss1

	boss2.is_real = true
	boss2.can_attack = true
	boss2.projetil_direction = Global.direction_projetil_boss2
	
	start_attack_loop()

func _process(delta: float) -> void:
	pass
		
	
func start_attack_loop() -> void:
	while Global.phase == 1:
		await get_tree().create_timer(15).timeout
		switch_boss()

"""func asdsad() -> void:
	if Global.boss_life >= 65:
		Global.phase = 1
	elif Global.boss_life >= 40:
		Global.phase = 2
		if boss1.is_real:
			$AnimatedSprite2D.play("changing_fase1")
			boss1.is_changing_fase = true
			await $AnimatedSprite2D.animation_finished
		else:
			$AnimatedSprite2D.play("dying_fase1")
			is_changing_fase = true
			await $AnimatedSprite2D.animation_finished
		is_changing_fase = false
		
	elif Global.boss_life >= 20:
		Global.phase = 3
		print(Global.boss_life) 
"""
func switch_boss(): #implement the animations

	$"../Boss1/AnimatedSprite2D".play("hit_fase1")
	await $"../Boss1/AnimatedSprite2D".animation_finished
	
	$"../Boss2/AnimatedSprite2D".play("hit_fase1")
	await $"../Boss2/AnimatedSprite2D".animation_finished


	boss1.is_real = !boss1.is_real
	boss2.is_real = !boss2.is_real

	boss1.can_attack = !boss1.can_attack
	boss2.can_attack = !boss2.can_attack

	print("Trocaram!")
	
	
	
	
	
	
	
	
	
