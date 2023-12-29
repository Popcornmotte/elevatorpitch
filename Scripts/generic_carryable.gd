extends Node

@export var type : Item.TYPE

func onAreaEntered(body):
	if body.name == "player":
		Global.player.addCarryable(self)
		if !Global.tutorialsCompleted[1]:
			Global.elevator.startFuelTutorial()

func onAreaExit(body):
	if body.name == "player":
		Global.player.removeCarryable(self)

func getType():
	return type
