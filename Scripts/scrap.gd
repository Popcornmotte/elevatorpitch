extends Node2D


@export var type : Item.TYPE

func onAreaEntered(body):
	if body.name == "player":
		Global.player.add_carryable(self)
		
func onAreaExit(body):
	if body.name == "player":
		Global.player.remove_carryable(self)

func getType():
	return type
