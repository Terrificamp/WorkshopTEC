extends Node2D

@onready var boss1 = $"../Boss1"
@onready var boss2 = $"../Boss2"



var life = 20#just a test
var phase = 1# 1,2,3

func _ready():

	boss1.is_real = true
	boss1.can_attack = true
	boss1.projetil_direction = Global.direction_projetil_boss1

	boss2.is_real = false
	boss2.can_attack = false
	boss2.projetil_direction = Global.direction_projetil_boss2

func switch_boss(): #implement the animations

	boss1.is_real = !boss1.is_real
	boss2.is_real = !boss2.is_real

	boss1.can_attack = !boss1.can_attack
	boss2.can_attack = !boss2.can_attack

	print("Trocaram!")
