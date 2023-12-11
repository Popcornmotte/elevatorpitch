extends GenericInteractible

var controlArms=false

func use():
	controlArms=!controlArms#change whether arms are being controlled or not
	if Global.elevator:# this makes the scene still useable on its own
		print("control arms is ", controlArms)
		Global.elevator.control(controlArms)
		if controlArms:
			Global.player.zoomIn(false)
		else:
			Global.player.zoomIn(true)

