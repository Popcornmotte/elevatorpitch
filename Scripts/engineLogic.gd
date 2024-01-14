extends GenericDestroyable

@onready var repairStation=find_child("Repair")

var startup = preload("res://Assets/Audio/sfx/engine_start.wav")
var loop = preload("res://Assets/Audio/sfx/engine_loop.wav")
var shutoff = preload("res://Assets/Audio/sfx/engine_shutoff.wav")

@export var animation : AnimationPlayer
@onready var sprite = $EngineSprite
@onready var audioPlayer = $EngineSound
var stopped = false

func _ready():
	if Global.elevator.moving:
		#animation.play("EngineJiggle")
		sprite.play()
		audioPlayer.play()
	else:
		sprite.pause()
		#animation.pause()
		stopped = true

func startEngine():
	if(stopped):
		stopped = false
		#animation.play("EngineJiggle")
		sprite.play()
		audioPlayer.stream = startup
		audioPlayer.play()

func stopEngine():
	if(!stopped):
		stopped = true
		#animation.pause()
		sprite.pause()
		audioPlayer.stream = shutoff
		audioPlayer.play()

func damaged():
	repairStation.visible=true
	repairStation.enableOptionalRepair()

func disable():
	sprite.pause()
	$Smoke.emitting = true
	repairStation.visible=true
	repairStation.enableRepair()
	Global.elevator.startLeaking()

func repaired():
	$Smoke.emitting = false
	repairStation.visible=false
	Global.elevator.stopLeaking()


func _on_engine_sound_finished():
	if(!stopped && Global.elevator.fuel > 0):
		audioPlayer.stream = loop
		audioPlayer.play()
		pass
	elif(!stopped):
		stopEngine()
		pass
	pass # Replace with function body.
