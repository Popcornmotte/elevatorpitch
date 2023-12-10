extends AudioStreamPlayer2D
class_name ElevatorEngine

var startup = preload("res://Assets/Audio/sfx/engine_start.wav")
var loop = preload("res://Assets/Audio/sfx/engine_loop.wav")
var shutoff = preload("res://Assets/Audio/sfx/engine_shutoff.wav")

@export var animation : AnimationPlayer
@export var sprite : AnimatedSprite2D

var stopped = false

func _ready():
	if Global.elevator.moving:
		animation.play("EngineJiggle")
		sprite.play()
	else:
		stopped = true

func startEngine():
	if(stopped):
		print("Start engine")
		stopped = false
		animation.play("EngineJiggle")
		sprite.play()
		stream = startup
		play()

func stopEngine():
	print("Stop engine")
	stopped = true
	animation.pause()
	sprite.pause()
	stream = shutoff
	play()

func _on_finished():
	if(Global.elevator.fuel > 0):
		stream = loop
		play()
	elif(!stopped):
		stopEngine()
