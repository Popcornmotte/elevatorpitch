extends GenericInteractible

var control_arms=false

func interact():
	control_arms=!control_arms#change whether arms are being controlled or not
	if Global.elevator:# this makes the scene still useable on its own
		Global.elevator.control(control_arms)
		if control_arms:
			Global.player.zoomIn(false)
		else:
			Global.player.zoomIn(true)

