extends Node2D
class_name PhysicalArm

var upperArmPhys : RigidBody2D
var lowerArmPhys : RigidBody2D
var clawPhys : RigidBody2D
var sparks : GPUParticles2D

var functional = true
var repairTimeMax = 5.0
var repairTime = repairTimeMax

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
	
	sparks = upperArmPhys.find_child("Sparks")
	
	pass # Replace with function body.

func betterMod(a : float, b : float):
	var res = fmod(a,b)
	if(res < 0):
		res += b
	return res

func rotatePart(delta : float, phys : RigidBody2D, ref : Bone2D):
	var diff = 0.0
	if(left):
		diff = (betterMod(phys.global_rotation,2*PI) - betterMod(ref.global_rotation,2*PI))
	else:
		diff = phys.global_rotation - ref.global_rotation
	if(abs(diff) > PI):
		diff = (2*PI - diff)
	phys.angular_velocity = -diff * acceleration * delta
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(functional):
		rotatePart(delta, upperArmPhys, upperArmRef)
		rotatePart(delta, lowerArmPhys, lowerArmRef)
		rotatePart(delta, clawPhys, clawRef)
	pass
	
func disable():
	#return
	functional = false
	sparks.emitting = true
	upperArmPhys.gravity_scale = 10
	lowerArmPhys.gravity_scale = 10
	clawPhys.gravity_scale = 10
	repairTime = repairTimeMax
	
func repair(delta):
	#return
	repairTime -= delta
	if(repairTime <= 0):
		functional = true
		sparks.emitting = false
		upperArmPhys.gravity_scale = 0
		lowerArmPhys.gravity_scale = 0
		clawPhys.gravity_scale = 0
