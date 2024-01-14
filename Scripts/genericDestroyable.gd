extends Node2D

class_name GenericDestroyable
@export var health:int=5
@onready var maxHealth=health
@export var damagedThreshold:int=9
var explosion = preload("res://Scenes/Objects/explosion.tscn")
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
			Global.elevator.newBrokenModule()
			update=false
		disable()

func spawnExplosion(position:Vector2):
	var newExplosion = explosion.instantiate()
	newExplosion.global_position = position
	newExplosion.set_collision_mask_value(3,false)#disable collision
	get_parent().call_deferred("add_child",newExplosion)
	
			
func repair():
	health=maxHealth
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
