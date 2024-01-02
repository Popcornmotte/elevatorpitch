extends GenericInteractible

@onready var dropeZoneRight=get_node("../DropZoneRight")
@export var fuelMultiplier=15
var newFuel=0

func use():
	newFuel=dropeZoneRight.returnFuelCount()
	dropeZoneRight.removeFuel()
	if newFuel > 0 and Global.elevator:#make sure that elevator exists, so that the interior scene can still be used for debugging
		Global.elevator.fuel+=newFuel*fuelMultiplier
		Global.elevator.updateFuel()
		Global.elevator.fuelAlert.visible = false
		Global.tutorialsCompleted[1] = true
