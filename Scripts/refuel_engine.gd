extends Node2D

const REFUEL = preload("res://Assets/Audio/sfx/refuel.wav")
const DROP=preload("res://Assets/Audio/sfx/spill.wav")
var currentlyRefueling=false
var stoppedFromTimer=false
var lowThreshold=1.0 #s
var highThreshold=2.0 #s
var refuelling=false
#multiplier depend on how long player interacts with refuel station
@export var fuelLow=10
@export var fuelMedium=12.5
@export var fuelHigh=15
var sfxRefuel
# Called when the node enters the scene tree for the first time.
func _ready():
	appearNormal()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if refuelling:
		visualiseFueling()
		if(sfxRefuel):
			if(!sfxRefuel.playing):
				sfxRefuel = Audio.playSfx(REFUEL,true)
		else:
			sfxRefuel=Audio.playSfx(REFUEL,true)
		

func prepareRefuel():
	$RefuelEngineAnimatedSprite2D.play("open")

func appearNormal():
	$RefuelEngineAnimatedSprite2D.play("normal")

func visualiseFueling():
	var timeToWait=$RefuelEngineTimer.get_wait_time()
	var timeDifference=timeToWait-$RefuelEngineTimer.get_time_left()
	if timeDifference>highThreshold:
		$RefuelEngineAnimatedSprite2D.play("filled2")
	elif timeDifference>lowThreshold:
		$RefuelEngineAnimatedSprite2D.play("filled1")
	else :
		$RefuelEngineAnimatedSprite2D.play("open")

func fuelEngine(fuel):
	if Global.elevator:#make sure that elevator exists, so that the interior scene can still be used for debugging
		Global.elevator.fuel+=fuel
		Global.elevator.updateFuel()
		Global.elevator.fuelAlert.visible = false
		
func calculateRefuelAmount(passedTime):
	var timeToWait=$RefuelEngineTimer.get_wait_time()
	var timeDifference=timeToWait-passedTime
	if timeDifference>highThreshold:
		fuelEngine(fuelHigh)
	elif timeDifference>lowThreshold:
		$RefuelEngineDropletAnimatedSprite2D.visible=true
		$RefuelEngineDropletAnimatedSprite2D.play("droplet")
		Audio.playSfx(DROP)
		fuelEngine(fuelMedium)
	else :
		$RefuelEngineDropletAnimatedSprite2D.visible=true
		Audio.playSfx(DROP)
		$RefuelEngineDropletAnimatedSprite2D.play("droplet")
		fuelEngine(fuelLow)
	$RefuelEngineAnimatedSprite2D.play("open")
	Global.player.removeFuel()
	
	
func startRefuel():
	if not currentlyRefueling:
		$RefuelEngineTimer.start()
		currentlyRefueling=true
		refuelling=true
	
func stopRefuel(stoppedFromTimer=false):#special case when stopped from timer
	if currentlyRefueling:
		currentlyRefueling=false
		refuelling=false
		if stoppedFromTimer: 
			calculateRefuelAmount(0)
		else:
			calculateRefuelAmount($RefuelEngineTimer.get_time_left())
			$RefuelEngineTimer.stop()

func _on_refuel_engine_timer_timeout():
	stopRefuel(true)


func _on_refuel_engine_droplet_animated_sprite_2d_animation_finished():
	print("finished anim")
	$RefuelEngineDropletAnimatedSprite2D.visible=false
