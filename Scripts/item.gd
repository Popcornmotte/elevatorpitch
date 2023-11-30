extends Node

class_name Item

enum TYPE {Fuel, Ammo, Scrap, Cargo, Luggage}
@export var type : TYPE
var objectPath
# Called when the node enters the scene tree for the first time.
func _init(typeArg : TYPE):
	type = typeArg
	match type:
		TYPE.Cargo:
			objectPath = "res://Scenes/Objects/Items/crate.tscn"
		TYPE.Fuel:
			pass
		TYPE.Ammo:
			pass
		TYPE.Scrap:
			pass
		TYPE.Luggage:
			pass


func checkType(checkedType : TYPE) -> bool:
	return (type == checkedType)

func getObjectInstance():
	if objectPath != null:
		return objectPath
	else:
		printerr("Item: trying to instantiate an item for which no reference object exists in class Item")
		return null
