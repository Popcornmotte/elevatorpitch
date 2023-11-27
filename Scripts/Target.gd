extends CharacterBody2D

@export var restingPosition : Node2D
@export var rightTarget = true

var SPEED = 10.0
var LERP_WEIGHT = 0.05
var thresholdDist = 0
var Emitter : Node2D

var speed = 0.0
var motion = Vector2(0,0)
var decelerate = false

var isControlled = true

var armAnchorPos : Vector2

func _ready():
	armAnchorPos = Global.elevator.global_position
	if rightTarget:
		armAnchorPos += Vector2(96,0)
	else:
		armAnchorPos -= Vector2(96,0)

func control(isBeingControlled : bool):
	isControlled = isBeingControlled
	if (!isControlled):
		global_position = restingPosition.global_position

func move(delta):
	#mouse position that the target moves towards
	var mousePos = get_global_mouse_position()
	velocity = global_position.direction_to(mousePos).normalized() * 600
	return

func _physics_process(delta):
	
	#if mouse is on other side of elevator reset target to rest pos
	#if mouse is near the elevator(or the arm base) move with physics and collision
	#if mouse is a little further then just attach target to mouse pos
	if(isControlled):
		if(rightTarget):
			if(Global.elevator.get_local_mouse_position().x <= 0):
				global_position = restingPosition.global_position
				return
			elif(armAnchorPos.distance_to(get_global_mouse_position()) > 200):
				global_position = get_global_mouse_position()
				return
		else:
			if(Global.elevator.get_local_mouse_position().x >= 0):
				global_position = restingPosition.global_position
				return
			elif(armAnchorPos.distance_to(get_global_mouse_position()) > 200):
				global_position = get_global_mouse_position()
				return
				
		move(delta)
		move_and_slide()
	#print(str(motion))
	#move_and_collide(motion)
