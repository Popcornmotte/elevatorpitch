extends Node2D

var upperArmPhys : RigidBody2D
var lowerArmPhys : RigidBody2D
var clawPhys : RigidBody2D

@export var upperArmRef : Bone2D
@export var lowerArmRef : Bone2D
@export var clawRef : Bone2D

@export var acceleration = 200.0

@export var left = false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	upperArmPhys = find_child("UpperArm")
	lowerArmPhys = find_child("LowerArm")
	clawPhys = find_child("Claw")
	
	pass # Replace with function body.

func betterMod(a : float, b : float):
	var res = fmod(a,b)
	if(res < 0):
		res += b
	return res

func rotatePart(delta : float, phys : RigidBody2D, ref : Bone2D):
	var diff = (betterMod(phys.global_rotation,2*PI) - betterMod(ref.global_rotation,2*PI))
	if(abs(diff) > PI):
		diff = (2*PI - diff)
	phys.angular_velocity = -diff * acceleration * delta
	if(left && abs(diff) > 2):
		print("left arm diff: "+str(diff))
		if(left && abs(diff) > 12):
			print(str(phys.global_rotation) + ", " + str(ref.global_rotation))
	#phys.angular_velocity -= ((PI - diff) / PI) * phys.angular_velocity
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	rotatePart(delta, upperArmPhys, upperArmRef)
	rotatePart(delta, lowerArmPhys, lowerArmRef)
	rotatePart(delta, clawPhys, clawRef)
	
	pass
