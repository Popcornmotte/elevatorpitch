extends Node2D

var upperArmPhys : RigidBody2D
var lowerArmPhys : RigidBody2D
var clawPhys : RigidBody2D

@export var upperArmRef0 : Bone2D
@export var lowerArmRef0 : Bone2D
@export var clawRef0 : Bone2D

@export var upperArmRef1 : Bone2D
@export var lowerArmRef1 : Bone2D
@export var clawRef1 : Bone2D

@export var acceleration = 200.0

var upperArmRef : Bone2D
var lowerArmRef : Bone2D
var clawRef : Bone2D

func switchRefs(low : bool):
	if(!low):
		upperArmRef = upperArmRef0
		lowerArmRef = lowerArmRef0
		clawRef = clawRef0
	else:
		upperArmRef = upperArmRef1
		lowerArmRef = lowerArmRef1
		clawRef = clawRef1
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	upperArmPhys = find_child("UpperArm")
	lowerArmPhys = find_child("LowerArm")
	clawPhys = find_child("Claw")
	
	pass # Replace with function body.

func rotatePart(delta : float, phys : RigidBody2D, ref : Bone2D):
	var diff = (phys.global_rotation - ref.global_rotation)
	if(abs(diff) > PI):
		diff = (2*PI - diff)
	phys.angular_velocity = -diff * acceleration * delta
	#phys.angular_velocity -= ((PI - diff) / PI) * phys.angular_velocity
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if(Global.elevator.get_local_mouse_position().y < 0):
		switchRefs(false)
	else:
		switchRefs(true)
	
	rotatePart(delta, upperArmPhys, upperArmRef)
	rotatePart(delta, lowerArmPhys, lowerArmRef)
	rotatePart(delta, clawPhys, clawRef)
	
	pass
