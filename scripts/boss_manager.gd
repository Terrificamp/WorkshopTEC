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
	while true:
		await get_tree().create_timer(15).timeout
		switch_boss()

func switch_boss(): #implement the animations

	boss1Anime.play("hit")
	await boss1Anime.animation_finished
	
	boss2Anime.play("hit")
	await boss2Anime.animation_finished
	
	boss1.is_real = !boss1.is_real
	boss2.is_real = !boss2.is_real

	boss1.can_attack = !boss1.can_attack
	boss2.can_attack = !boss2.can_attack
	
	print("Trocaram!")
	
	
func _check_boss_life() -> void:
	if Global.boss_life_1 == 0:
		if boss1.is_real:
			boss1Anime.play("changing_fase1")
			await boss1Anime.animation_finished
		
			boss2Anime.play("dying_fase1")
			await boss2Anime.animation_finished
	
	
	
	
	
