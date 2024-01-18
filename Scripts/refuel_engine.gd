extends Node2D

const REFUEL = preload("res://Assets/Audio/sfx/refuel.wav")
const DROP=preload("res://Assets/Audio/sfx/spill.wav")
var currentlyRefueling=false
var stoppedFromTimer=false
var lowThreshold=1.0 #s
var highThreshold=2.0 #s
var refuelling=false
var fuelAtStart = 0.0
#multiplier depend on how long player interacts with refuel station
@export var fuelLow=0.3
@export var fuelMedium=0.6
@export var fuelHigh=1.0
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
		Global.player.carriedFuel -= 6.25 * delta
		if Global.player.carriedFuel <= 0:
			stopRefuel(true)
	if $Puddle/FadeTimer.get_time_left() < 1.0:
		$Puddle.set_modulate(Color(1,1,1,0).lerp(Color(1,1,1,1), $Puddle/FadeTimer.get_time_left()))

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
		#print("adding " + str(fuel) + " fuel")
		Global.elevator.fuel+=fuel
		Global.elevator.fuel = min(Global.elevator.fuel, Global.elevator.maxFuel)
		Global.elevator.updateFuel()
		Global.elevator.fuelAlert.visible = false
		Global.tutorialsCompleted[1] = true
		
func calculateRefuelAmount(passedTime):
	var timeToWait=$RefuelEngineTimer.get_wait_time()
	var timeDifference=timeToWait-passedTime
	var fuelled = Fuel.FUEL_PER_CANISTER
	if timeDifference>highThreshold:
		fuelled *= fuelHigh
	elif timeDifference>lowThreshold:
		#$RefuelEngineDropletAnimatedSprite2D.visible=true
		#$RefuelEngineDropletAnimatedSprite2D.play("droplet")
		$FuelSpill.visible = true
		$FuelSpill.play("spill")
		Audio.playSfx(DROP)
		fuelled *= fuelMedium
	else :
		#$RefuelEngineDropletAnimatedSprite2D.visible=true
		#$RefuelEngineDropletAnimatedSprite2D.play("droplet")
		$FuelSpill.visible = true
		$FuelSpill.play("spill")
		Audio.playSfx(DROP)
		fuelled *= fuelLow
	fuelEngine(fuelled)
	$RefuelEngineAnimatedSprite2D.play("open")
	Global.player.removeFuel(fuelAtStart - min(fuelAtStart, fuelled))
	
	
func startRefuel():
	if not currentlyRefueling:
		$RefuelEngineTimer.start()
		currentlyRefueling=true
		refuelling=true
		fuelAtStart = Global.player.carriedFuel
	
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
	#print("finished anim")
	$RefuelEngineDropletAnimatedSprite2D.visible=false

func _on_fuel_spill_animation_finished():
	$FuelSpill.visible = false
	$Puddle/FadeTimer.start()
	$Puddle.visible = true
	$Puddle.set_modulate(Color(1,1,1,1))
