extends Node

@export var type : Item.TYPE

func onAreaEntered(body):
	if body.name == "player":
		Global.player.addCarryable(self)
		
func onAreaExit(body):
	if body.name == "player":
		Global.player.removeCarryable(self)

func getType():
	return type
