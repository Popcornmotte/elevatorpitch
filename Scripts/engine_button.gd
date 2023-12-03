
extends GenericInteractible
@onready var dropeZoneRight=get_node("../DropZoneRight")
var newFuel=0

func interact():
	newFuel=dropeZoneRight._return_fuel_count()
	dropeZoneRight._remove_fuel()
	if Global.elevator:#make sure that elevator exists, so that the interior scene can still be used for debugging
		Global.elevator.fuel+=newFuel
		print("Updated fuel: ",Global.elevator.fuel)
