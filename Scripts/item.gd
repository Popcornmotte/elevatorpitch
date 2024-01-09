extends Node

class_name Item

enum TYPE {Fuel, Ammo, Scrap, Cargo}
@export var type : TYPE
var objectPath
# Called when the node enters the scene tree for the first time.
func _init(typeArg : TYPE):
	type = typeArg
	match type:
		TYPE.Cargo:
			objectPath = "res://Scenes/Objects/Items/crate.tscn"
		TYPE.Fuel:
			objectPath = "res://Scenes/Objects/Items/fuel.tscn"
		TYPE.Ammo:
			pass
		TYPE.Scrap:
			pass

func checkType(checkedType : TYPE) -> bool:
	return (type == checkedType)

func getObjectInstance():
	if objectPath != null:
		return objectPath
	else:
		printerr("Item: trying to instantiate an item for which no reference object exists in class Item")
		return null
