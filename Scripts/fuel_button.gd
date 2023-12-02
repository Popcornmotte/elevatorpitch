extends "res://Scripts/generic_interactable.gd"


const FUEL=preload("res://Scenes/Objects/Items/fuel.tscn")
@onready var funnel=get_node("../DropFunnel")
@onready var dropPosition=funnel.position+Vector2(-25,-40)

func interact():
	var loadedFuel=FUEL.instantiate()
	loadedFuel.position=dropPosition
	print("drop")
	add_child(loadedFuel)
		






