extends "res://Scripts/generic_interactable.gd"

var turnOn=true
@onready var brakeSprite = get_node("BrakeSprite")

func _use_brake(turnOnBrake):#use this function also externally when no more fuel is available
	if(turnOnBrake):
		brakeSprite.play("turn_on")
		if Global.elevator:#check that elevator exists 
			Global.elevator.moving=true
	else:
		brakeSprite.play("turn_off")
		if Global.elevator:#check that elevator exists 
			Global.elevator.moving=false
			
func _interact():
	_use_brake(turnOn)
	turnOn=!turnOn
		

