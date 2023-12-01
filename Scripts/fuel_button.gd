extends "res://Scripts/generic_interactable.gd"


const FUEL=preload("res://Scenes/Objects/fuel.tscn")
@onready var funnel=get_node("../DropFunnel")
@onready var dropPosition=funnel.position+Vector2(-25,-40)

func interact():
	print("new fuel")
	var loadedFuel=FUEL.instantiate()
	loadedFuel.position=dropPosition
	if Global.elevator:#make sure that elevator exists, so that the interior scene can still be used for debugging
		Global.elevator.add_child(loadedFuel)
	else:
		add_child(loadedFuel)
		






