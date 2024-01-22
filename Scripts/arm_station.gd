extends Node2D

var controlArms=false
var playerPresent = false


func _input(event):
	if Input.is_action_just_pressed("interact"):
		if playerPresent:
			use()

func use():
	if !Global.player.get_node("PlayerCam/ZoomAnimation").is_playing():
		controlArms=!controlArms#change whether arms are being controlled or not
		if Global.elevator:# this makes the scene still useable on its own
			Global.elevator.control(controlArms)
			if controlArms:
				Global.player.zoomIn(false)
			else:
				Global.player.zoomIn(true)



func _on_arm_station_area_body_entered(body):
	if body.name == "player":
		$ChuteTutorialTimer.start()
		playerPresent = true
	pass # Replace with function body.


func _on_arm_station_area_body_exited(body):
	if body.name == "player":
		playerPresent = false


func _on_chute_tutorial_timer_timeout():
	Global.optionsMenu.switch(Global.TUTORIAL_INDICES.CHUTES)
