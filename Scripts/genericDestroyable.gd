extends Node

@export var health=10
@export var damagedThreshold=5

func damage(damage:int):
	health-=damage
	if health < damagedThreshold:
		damaged()
	elif health<=0:
		broken()

func damaged():
	print("damaged module!")

func broken():
	print("broken module!")
