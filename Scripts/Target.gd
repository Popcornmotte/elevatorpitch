extends CharacterBody2D

@export var SPEED = 10.0
@export var LERP_WEIGHT = 0.05
@export var thresholdDist = 10

@export var Emitter : Node2D

var speed = 0.0
var motion = Vector2(0,0)
var decelerate = false

func move(delta):
	#mouse position that the target moves towards
	var mousePos = get_viewport().get_mouse_position()
	
	#If distance is greater than [thresholdDist]+speed*2 and
	#not already decelerating then accelerate
	if global_position.distance_to(mousePos) > (thresholdDist+speed*2) && !decelerate:
		speed = lerp(speed, SPEED, LERP_WEIGHT)
		Emitter.emitting = true
	#otherwise deccelerate 
	else:
		if(speed>0):
			decelerate = true
			Emitter.emitting = false
		speed = lerp(speed, 0.0, LERP_WEIGHT)
		#hot-fix to stop 'jittering' at very slow speeds and reset 'decelerate'
		if(global_position.distance_to(mousePos) > (5)):
			speed = 0.0
			decelerate = false
		#motion = lerp(motion, Vector2(0,0),delta * LERP_WEIGHT*10)
	motion = global_position.direction_to(mousePos).normalized() * speed

func _physics_process(delta):

	#print(str(speed))
	move(delta)
	#print(str(motion))
	move_and_collide(motion)
	pass
