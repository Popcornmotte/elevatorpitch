extends GenericInteractible

const BRAKESOUND = preload("res://Assets/Audio/sfx/lever.wav")
const ALERT = preload("res://Assets/Audio/sfx/enemyAlert.wav")
const ERROR = preload("res://Assets/Audio/sfx/error.wav")
var alarmIsSounding = false
var turnOn=true
@onready var brakeSprite = get_node("BrakeSprite")
@onready var alarmLightAnimation = get_parent().get_node("AlertLight/AlertAnimation")

func turnOffLightOnly():
	alarmLightAnimation.stop()

func use_brake(use : bool, alarm = false):#use this function also externally when no more fuel is available
	Audio.playSfx(BRAKESOUND)
	if(use):
		print("brake on")
		if alarm:
			alarmIsSounding = true
			Audio.playSfx(ALERT)
			alarmLightAnimation.play("alert")
		brakeSprite.play("turn_on")
		turnOn=true
		if Global.elevator:#check that elevator exists 
			Global.elevator.moving=false
	else:
		if Global.aliveEnemies > 0:
			Audio.playSfx(ERROR)
			return
		print("brake off")
		if alarmIsSounding:
			alarmIsSounding = false
			alarmLightAnimation.stop()
		brakeSprite.play("turn_off")
		turnOn=false
		if Global.elevator:#check that elevator exists 
			Global.elevator.moving=true
			
func interact():
	turnOn=!turnOn
	use_brake(turnOn)
	
		

