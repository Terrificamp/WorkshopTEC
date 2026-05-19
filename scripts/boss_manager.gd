extends Node2D

@onready var boss1 = $"../Boss1"
@onready var boss2 = $"../Boss2"
@onready var boss1Shader = $"../Boss1/AnimatedSprite2D".material
@onready var boss2Shader = $"../Boss2/AnimatedSprite2D".material


func _ready():
	Global.take_damage_boss1.connect(flashboss1)
	Global.take_damage_boss2.connect(flashboss2)

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
	
func flashboss1():
	boss1Shader.set_shader_parameter("flash_amount", 0.5)
	await get_tree().create_timer(0.1).timeout 
	boss1Shader.set_shader_parameter("flash_amount", 0)
func flashboss2():
	boss2Shader.set_shader_parameter("flash_amount", 0.5)
	await get_tree().create_timer(0.1).timeout 
	boss2Shader.set_shader_parameter("flash_amount", 0)
func _take_damege(amount,  boss) -> void:
	Global.boss_life -= amount
	print("asddddddddd")

	
	
	
	
	
	
	
	
