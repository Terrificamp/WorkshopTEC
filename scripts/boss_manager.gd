extends Node2D

@onready var boss1 = $"../Boss1"
@onready var boss2 = $"../Boss2"




func _ready():
	

	boss1.is_real = false
	boss1.can_attack = false
	boss1.projetil_direction = Global.direction_projetil_boss1

	boss2.is_real = true
	boss2.can_attack = true
	boss2.projetil_direction = Global.direction_projetil_boss2
	
	start_attack_loop()

func _process(delta: float) -> void:
	if Global.boss_life >= 40:
		Global.phase = 3
	elif Global.boss_life >= 25:
		Global.phase = 2
		
	
func start_attack_loop() -> void:
	while true:
		await get_tree().create_timer(15).timeout
		switch_boss()


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
	
	
func _take_damege(amount,  boss) -> void:
	Global.boss_life -= amount
	print("asddddddddd")
	
	
	
	
	
	
	
	
