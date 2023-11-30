extends CharacterBody2D

@export var restingPosition : Node2D
@export var rightTarget = true
@export var claw : Node

var SPEED = 10.0
var LERP_WEIGHT = 0.05
var thresholdDist = 0
var Emitter : Node2D

var speed = 0.0
var motion = Vector2(0,0)
var decelerate = false

var isControlled = true

var armAnchorPos : Vector2
var line : Line2D

func _ready():
	armAnchorPos = Global.elevator.global_position
	line = find_child("FlingLine")
	line.points[0].x = 0
	line.points[0].y = 0
	line.points[1].x = 0
	line.points[1].y = 0
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
	
func isActive():
	if(rightTarget):
		return Global.elevator.get_local_mouse_position().x > 0
	else:
		return Global.elevator.get_local_mouse_position().x < 0

func follow_mouse(delta : float):
	#if mouse is on other side of elevator reset target to rest pos
	#if mouse is near the elevator(or the arm base) move with physics and collision
	#if mouse is a little further then just attach target to mouse pos
	if(isControlled):
		if(isActive()):
			if(armAnchorPos.distance_to(get_global_mouse_position()) > 200):
				global_position = get_global_mouse_position()
		else:
			global_position = restingPosition.global_position

		move(delta)
		move_and_slide()

func draw_fling_dir():
	if(isControlled && isActive()):
		var mousePos = line.get_local_mouse_position()
		line.points[1].x = mousePos.x
		line.points[1].y = mousePos.y

func _physics_process(delta):
	if(Input.is_action_pressed("Fling") && claw.grabbing):
		draw_fling_dir()
	else:
		follow_mouse(delta)
	
func _process(delta):
	if(Input.is_action_just_released("Fling")):
		var dir = Vector2(line.points[1].x, line.points[1].y)
		claw.setFlingTargetDir(dir)
		
		line.points[1].x = 0
		line.points[1].y = 0
	
