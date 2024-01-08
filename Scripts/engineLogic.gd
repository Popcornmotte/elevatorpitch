extends GenericDestroyable

@onready var repairStation=find_child("Repair")

func damaged():
	repairStation.visible=true
	repairStation.enableOptionalRepair()

func disable():
	repairStation.visible=true
	repairStation.enableRepair()
	Global.elevator.startLeaking()

func repaired():
	repairStation.visible=false
	Global.elevator.stopLeaking()
