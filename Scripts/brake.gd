extends GenericInteractible

const BRAKESOUND = preload("res://Assets/Audio/sfx/lever.wav")
const ALERT = preload("res://Assets/Audio/sfx/enemyAlert.wav")
const ERROR = preload("res://Assets/Audio/sfx/error.wav")
var alarmIsSounding = false
var turnOn=false
@onready var brakeSprite = get_node("BrakeSprite")
@onready var alarmLightAnimation = get_parent().get_node("AlertLight/AlertAnimation")
enum SPEED {Off,Normal,Fast}
var currentSpeed=SPEED.Normal;

func turnOffLightOnly():
	alarmLightAnimation.stop()

func use():
	var changeTo:SPEED
	match currentSpeed:
		SPEED.Off:
			changeTo=SPEED.Normal
		SPEED.Normal:
			changeTo=SPEED.Fast
		SPEED.Fast:
			changeTo=SPEED.Off
	useBrake(changeTo)


func useBrake(changeTo : SPEED, alarm = false, moveEngine=true):#use this function also externally when no more fuel is available
	Audio.playSfx(BRAKESOUND)
	if alarm:
		alarmIsSounding = true
		Audio.playSfx(ALERT)
		alarmLightAnimation.play("alert")
		match currentSpeed:
			SPEED.Fast:
				brakeSprite.play("fast_to_off")
			SPEED.Normal:
				brakeSprite.play("normal_to_off")
		currentSpeed=SPEED.Off
		if Global.elevator:#check that elevator exists 
			Global.elevator.moving=false
		return
	if not moveEngine:
		match currentSpeed:
			SPEED.Fast:
				brakeSprite.play("fast_to_off")
			SPEED.Normal:
				brakeSprite.play("normal_to_off")
		currentSpeed=SPEED.Off
		if Global.elevator:#check that elevator exists 
			Global.elevator.moving=false
		return
		
	if(moveEngine):
		if Global.aliveEnemies > 0:
			Audio.playSfx(ERROR)
			return
		match changeTo:
			SPEED.Off:
				if(currentSpeed==SPEED.Normal):
					brakeSprite.play("normal_to_off")
				elif(currentSpeed==SPEED.Fast):
					brakeSprite.play("fast_to_off")	
				turnOn=true
				if Global.elevator:#check that elevator exists 
					Global.elevator.moving=false
			SPEED.Fast:
				if Global.elevator:
					Global.elevator.moveFast()
				if(currentSpeed==SPEED.Normal):
					brakeSprite.play("normal_to_fast")
			SPEED.Normal:
				if Global.elevator:
					Global.elevator.moveNormal()
				if(currentSpeed==SPEED.Off):
					brakeSprite.play("off_to_normal")
				elif (currentSpeed==SPEED.Fast):
					brakeSprite.play("fast_to_normal")
				if Global.elevator:#check that elevator exists 
					Global.elevator.moving=true
		currentSpeed=changeTo
	else:
		
		if alarmIsSounding:
			alarmIsSounding = false
			alarmLightAnimation.stop()
		if currentSpeed==SPEED.Normal:
			brakeSprite.play("normal_to_off")
		else:
			brakeSprite.play("fast_to_off")
		currentSpeed=SPEED.Off
		turnOn=false
		if Global.elevator:#check that elevator exists 
			Global.elevator.moving=true
			Global.elevator.get_node("HullBody/EngineSound").startEngine()
	
	
	#if(use):
	#	if alarm:
	#		alarmIsSounding = true
	#		Audio.playSfx(ALERT)
	#		alarmLightAnimation.play("alert")
	#	brakeSprite.play("turn_on")
	#	turnOn=true
	#	if Global.elevator:#check that elevator exists 
	#		Global.elevator.moving=false
	#else:
	#	if Global.aliveEnemies > 0:
	#		Audio.playSfx(ERROR)
	#		return
	#	
#
#
