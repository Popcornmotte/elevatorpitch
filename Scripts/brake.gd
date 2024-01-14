extends GenericDestroyable

signal enemiesDetected

const BRAKESOUND = preload("res://Assets/Audio/sfx/lever.wav")
const ALERT = preload("res://Assets/Audio/sfx/enemyAlert.wav")
const ERROR = preload("res://Assets/Audio/sfx/error.wav")
var alarmIsSounding = false
@export var braking=false
@onready var brakeSprite = get_node("BrakeSprite")
@onready var alarmLightAnimation = get_parent().get_node("AlertLight/AlertAnimation")
enum SPEED {Off,Normal,Fast}
@export var currentSpeed=SPEED.Normal;
@export var locked = false
@onready var startLocked = locked
@onready var repairStation=find_child("RepairArea")
var operatingMode=OPERATIONMODE.Normal

func _ready():
	if Global.elevator:
		Global.elevator.moving=false
		
func _process(delta):
	match currentSpeed:
		SPEED.Off:
			Global.changeHeat(-2)
		SPEED.Normal:
			Global.changeHeat(1)
		SPEED.Fast:
			Global.changeHeat(5)
	
func damaged():
	repairStation.visible=true
	repairStation.enableOptionalRepair()
	operatingMode=OPERATIONMODE.Damaged

func disable():
	repairStation.visible=true
	repairStation.enableRepair()
	operatingMode=OPERATIONMODE.Broken
	if currentSpeed==SPEED.Fast:#if we are going fast, automatically slow down
		switchDown()

func repaired():
	repairStation.visible=false
	operatingMode=OPERATIONMODE.Normal
	
func turnOffLightOnly():
	alarmLightAnimation.stop()

func switchUp():
	if locked:
			Audio.playSfx(ERROR)
			return
	Audio.playSfx(BRAKESOUND)
	match currentSpeed:
		SPEED.Off:
			brakeSprite.play("off_to_normal")
			currentSpeed=SPEED.Normal
			if Global.elevator:
				Global.elevator.moveNormal()
				Global.elevator.moving=true
		SPEED.Normal:
			if operatingMode!=OPERATIONMODE.Broken: #cannot go into fast mode if broken
				if Global.elevator:
					Global.elevator.moveFast()
				brakeSprite.play("normal_to_fast")
				currentSpeed=SPEED.Fast	
			else:
				Audio.playSfx(ERROR)
				return
		SPEED.Fast:
			Audio.playSfx(ERROR)
			return

func noFuel():
	lock(false)

func switchDown():
	if locked:
			Audio.playSfx(ERROR)
			return
	Audio.playSfx(BRAKESOUND)
	match currentSpeed:
		SPEED.Off:
			Audio.playSfx(ERROR)
			return
		SPEED.Normal:
			if Global.elevator:
				Global.elevator.moving=false
			brakeSprite.play("normal_to_off")
			currentSpeed=SPEED.Off
		SPEED.Fast:
			if Global.elevator:
				Global.elevator.moveNormal()
			brakeSprite.play("fast_to_normal")
			currentSpeed=SPEED.Normal

# used when elevator encounters enemies or no more fuel available
func lock(enemies=true):
	if enemies: 
		alarmIsSounding = true
		Audio.playSfx(ALERT)
		if currentSpeed!=SPEED.Off:
			Audio.playSfx(BRAKESOUND)
		alarmLightAnimation.play("alert")
		if !Global.tutorialsCompleted[2]:
			enemiesDetected.emit()
	if not locked:
		Audio.playSfx(BRAKESOUND)
		match currentSpeed:
			SPEED.Fast:
				brakeSprite.play("fast_to_off")
			SPEED.Normal:
				brakeSprite.play("normal_to_off")
		currentSpeed=SPEED.Off
		locked = true
		if Global.elevator:#check that elevator exists 
			Global.elevator.moving=false
		return

func unlock():
	if startLocked:
		return
	if !Global.level or (Global.level and !Global.level.combat and Global.elevator.fuel > 0):
		locked = false
		if alarmIsSounding:
			Global.tutorialsCompleted[2] = true
		alarmIsSounding = false
