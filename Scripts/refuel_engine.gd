extends Node2D

var currentlyRefueling=false
var stoppedFromTimer=false
var lowThreshold=1.0 #s
var highThreshold=2.0 #s
# Called when the node enters the scene tree for the first time.
func _ready():
	appearNormal()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func prepareRefuel():
	$RefuelEngineOpen.visible=true
	$RefuelEngineNormal.visible=false

func appearNormal():
	$RefuelEngineOpen.visible=false
	$RefuelEngineNormal.visible=true

func calculateRefuelAmount(passedTime):
	var timeToWait=$RefuelEngineTimer.get_wait_time()
	var timeDifference=timeToWait-passedTime
	print("time to wait: ", timeToWait)
	print("time left: ", passedTime)
	print("Waited : ",timeDifference)
	print("high threshold: ", highThreshold)
	print("low threshold: ", lowThreshold)
	if timeDifference>highThreshold:
		print("highest reload")
	elif timeDifference>lowThreshold:
		print("medium reload")
	else :
		print("low reload")
	
	
func startRefuel():
	if not currentlyRefueling:
		print("startRefuel")
		$RefuelEngineTimer.start()
		currentlyRefueling=true
	
func stopRefuel(stoppedFromTimer=false):#special case when stopped from timer
	if currentlyRefueling:
		currentlyRefueling=false
		print("stopRefuel")
		if stoppedFromTimer: 
			calculateRefuelAmount(0)
		else:
			calculateRefuelAmount($RefuelEngineTimer.get_time_left())
			$RefuelEngineTimer.stop()

func _on_refuel_engine_timer_timeout():
	stopRefuel(true)
