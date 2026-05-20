extends Node2D

@onready var boss1 = $"../Boss1"
@onready var boss2 = $"../Boss2"
@onready var boss1Anime = $"../Boss1/AnimatedSprite2D"
@onready var boss2Anime = $"../Boss2/AnimatedSprite2D"
@export var boss_fase_2: PackedScene

var is_alive = true
var transitioning := false  # blocks _check_boss_life from running twice

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
	while is_alive:
		await get_tree().create_timer(15).timeout
		switch_boss()

func switch_boss():
	if !is_alive:
		return
	boss1Anime.play("hit")
	await boss1Anime.animation_finished
	boss2Anime.play("hit")
	
	await boss1Anime.animation_finished
	await boss2Anime.animation_finished
	boss1.is_real = !boss1.is_real
	boss2.is_real = !boss2.is_real
	boss1.can_attack = !boss1.can_attack
	boss2.can_attack = !boss2.can_attack
	print("Trocaram!")

func _check_boss_life() -> void:
	if Global.boss_life_1 <= 0 and not transitioning:  # only enters once
		is_alive = false
		transitioning = true
		if boss1.is_real:
			boss1Anime.play("changing")
			boss2Anime.play("dying")
			await boss2Anime.animation_finished
			await boss1Anime.animation_finished
			var old_global_position = boss1.global_position
			var boss_fase2_instance = boss_fase_2.instantiate() as CharacterBody2D
			boss1.get_parent().add_child(boss_fase2_instance)
			boss_fase2_instance.global_position = old_global_position
		else:
			boss2Anime.play("changing")
			boss1Anime.play("dying")
			await boss1Anime.animation_finished
			await boss2Anime.animation_finished
			var old_global_position = boss2.global_position
			var boss_fase2_instance = boss_fase_2.instantiate() as CharacterBody2D
			boss2.get_parent().add_child(boss_fase2_instance)
			boss_fase2_instance.global_position = old_global_position
		boss1.queue_free()
		boss2.queue_free()
