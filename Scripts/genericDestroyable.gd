extends Node2D

class_name GenericDestroyable
@export var health=10
@onready var maxHealth=health
@export var damagedThreshold=9
enum OPERATIONMODE {Normal, Damaged, Broken}
var update=true

func damage(damage:int):
	if health<0:
		return
	health-=damage
	if health < damagedThreshold and health>0:
		damaged()
	elif health<=0:
		if update: 
			print("new broken module")
			Global.elevator.newBrokenModule()
			update=false
		disable()

func repair():
	health=10
	Global.elevator.newFixedModule()
	update=true
	repaired()
		
#can be repaired to regain health, still partially functional
func damaged():
	pass

#has to be repaired, module is not functional
func disable():
	pass

func repaired():
	pass
