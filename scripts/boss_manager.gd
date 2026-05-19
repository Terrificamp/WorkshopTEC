extends Node2D

@onready var boss1 = $"../Boss1"
@onready var boss2 = $"../Boss2"



var life_phase1 = 85#20 - 1| 25 - 2| 40 - 3

var phase = 1# 1,2,3

func _ready():

	boss1.is_real = false
	boss1.can_attack = false
	boss1.projetil_direction = Global.direction_projetil_boss1

	boss2.is_real = true
	boss2.can_attack = true
	boss2.projetil_direction = Global.direction_projetil_boss2

func switch_boss(): #implement the animations

	boss1.is_real = !boss1.is_real
	boss2.is_real = !boss2.is_real

	boss1.can_attack = !boss1.can_attack
	boss2.can_attack = !boss2.can_attack

	print("Trocaram!")
	
func _take_damege(amount,  boss) -> void:
	Global.life_phase1 -= amount
	print("asddddddddd")
	
	
	
	
	
