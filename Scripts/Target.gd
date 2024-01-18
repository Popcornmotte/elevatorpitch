extends CharacterBody2D

@export var restingPosition : Node2D
@export var rightTarget = true
@export var claw : Node

var SPEED = 10.0
var LERP_WEIGHT = 0.05
var thresholdDist = 0
var Emitter : Node2D
@onready var raycast = $RayCast2D
var shapeRadius = 0.0

var speed = 0.0
var motion = Vector2(0,0)
var decelerate = false

var isControlled = true

var armAnchorPos : Vector2
var line : Line2D
var preFlingPos : Vector2
var previousMouseDist = 10000.0

func _ready():
	armAnchorPos = Global.elevator.global_position
	line = find_child("FlingLine")
	line.points[0].x = 0
	line.points[0].y = 0
	line.points[1].x = 0
	line.points[1].y = 0
	shapeRadius = $CollisionShape2D.shape.radius
	if rightTarget:
		armAnchorPos += Vector2(96,0)
	else:
		armAnchorPos -= Vector2(96,0)
	claw.target = self

func control(isBeingControlled : bool):
	isControlled = isBeingControlled
	if (!isControlled):
		global_position = restingPosition.global_position

func move(delta, targetPos : Vector2):
	var localTargetPos = targetPos - global_position
	raycast.target_position = localTargetPos
	#mouse position that the target moves towards
	var mousePos = raycast.get_collision_point()
	if !raycast.get_collider():
		mousePos = targetPos
	else:
		mousePos -= global_position.direction_to(mousePos) * shapeRadius
	var mouseDist = global_position.distance_to(mousePos)
	var magnitude = mouseDist/delta
	velocity = global_position.direction_to(mousePos) * magnitude
	previousMouseDist = mouseDist
	return

func isActive():
	if(claw.grabbing):
		return true
	if(rightTarget):
		return Global.elevator.get_local_mouse_position().x > 0.0
	else:
		return Global.elevator.get_local_mouse_position().x < 0.0

func follow_mouse(delta : float, mousePos : Vector2):
	#if mouse is on other side of elevator reset target to rest pos
	if(isControlled):
		if(isActive()):
				claw.setControlled(true)
				
				var mouseLocalToElevator = Global.elevator.get_local_mouse_position()
				if(rightTarget):
					mousePos.x -= min(0,mouseLocalToElevator.x)
				else:
					mousePos.x -= max(0,mouseLocalToElevator.x)
				
				move(delta, mousePos)
				move_and_slide()
		else:
			claw.setControlled(false)
			global_position = restingPosition.global_position


func draw_fling_dir():
	if(isControlled && isActive()):
		var startPos = preFlingPos - global_position
		line.points[0].x = startPos.x
		line.points[0].y = startPos.y
		
		var mousePos = line.get_local_mouse_position()
		line.points[1].x = mousePos.x
		line.points[1].y = mousePos.y

func _physics_process(delta):
	if(Input.is_action_just_pressed("Fling")):
		preFlingPos = global_position
	if(Input.is_action_pressed("Fling") && claw.grabbing):
		draw_fling_dir()
		var offsetDir = preFlingPos.direction_to(get_global_mouse_position()) * preFlingPos.distance_to(armAnchorPos) / 2
		var targetPos = global_position.lerp(preFlingPos - offsetDir, delta * 10)
		move(delta, targetPos)
		move_and_slide()
	else:
		follow_mouse(delta, get_global_mouse_position())

func _process(delta):
	if(Input.is_action_just_released("Fling")):
		var dir = Vector2(line.points[1].x, line.points[1].y)
		claw.setFlingTargetDir(dir)
		
		line.points[0].x = 0
		line.points[0].y = 0
		line.points[1].x = 0
		line.points[1].y = 0
	
