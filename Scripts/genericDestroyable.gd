extends Node2D

class_name GenericDestroyable
@export var health=10
@onready var maxHealth=health
@export var damagedThreshold=9
enum OPERATIONMODE {Normal, Damaged, Broken}

func damage(damage:int):
	health-=damage
	if health < damagedThreshold and health>0:
		damaged()
	elif health<=0:
		disable()

func repair(repairAmount:int):
	health+=repairAmount
	if health > damagedThreshold:
		repaired()
	elif health<=damagedThreshold:
		damaged()
		
#can be repaired to regain health, still partially functional
func damaged():
	pass

#has to be repaired, module is not functional
func disable():
	pass

func repaired():
	pass
