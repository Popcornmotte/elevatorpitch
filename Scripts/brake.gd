extends "res://Scripts/generic_interactable.gd"

const BRAKESOUND = preload("res://Assets/Audio/sfx/lever.wav")
var turnOn=true
@onready var brakeSprite = get_node("BrakeSprite")

func use_brake(turnOnBrake):#use this function also externally when no more fuel is available
	Audio.playSfx(BRAKESOUND)
	if(turnOnBrake):
		brakeSprite.play("turn_on")
		turnOn=true
		if Global.elevator:#check that elevator exists 
			Global.elevator.moving=true
	else:
		brakeSprite.play("turn_off")
		turnOn=false
		if Global.elevator:#check that elevator exists 
			Global.elevator.moving=false
			
func interact():
	turnOn=!turnOn
	use_brake(turnOn)
	
		

