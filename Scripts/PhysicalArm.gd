extends Node2D
class_name PhysicalArm

signal firstDestroyed

var upperArmPhys : RigidBody2D
var lowerArmPhys : RigidBody2D
var clawPhys : RigidBody2D
var sparks : GPUParticles2D

var functional = true
var elbowReversed = false
var claw : Claw
var lowerArmLength = 0.0

@export var upperArmRef : Bone2D
@export var lowerArmRef : Bone2D
@export var clawRef : Bone2D
@export var skeleton : Skeleton2D
@export var target : Node2D

@export var acceleration = 200.0

@export var left = false
@onready var repairStation=find_child("RepairArea")

# Called when the node enters the scene tree for the first time.
func _ready():
	upperArmPhys = find_child("UpperArm")
	lowerArmPhys = find_child("LowerArm")
	clawPhys = find_child("Claw")
	sparks = upperArmPhys.find_child("Sparks")
	
	lowerArmLength = lowerArmPhys.global_position.distance_to(clawPhys.global_position)
	pass # Replace with function body.

func rotatePart(delta : float, phys : RigidBody2D, ref : Bone2D):
	var diff = angle_difference(phys.global_rotation, ref.global_rotation)
	phys.angular_velocity = diff * acceleration * delta
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(functional):
		rotatePart(delta, upperArmPhys, upperArmRef)
		rotatePart(delta, lowerArmPhys, lowerArmRef)
		rotatePart(delta, clawPhys, clawRef)
	pass
	
func _integrate_forces(state):
	var elbowToTarget = lowerArmPhys.global_position.distance_to(target.global_position)
	clawPhys.position.x = min(elbowToTarget, lowerArmLength)
	
func setElbowDir(bendUp : bool):
	elbowReversed = !bendUp
	if claw.controlled:
		updateElbowDir(!elbowReversed)

func updateElbowDir(bendUp : bool):
	bendUp = !bendUp if left else bendUp
	skeleton.get_modification_stack().get_modification(0).flip_bend_direction = bendUp

func setControlled(value : bool):
	if value:
		updateElbowDir(!elbowReversed)
	else:
		updateElbowDir(true)

func disable():
	repairStation.visible=true
	repairStation.enable()
	functional = false
	sparks.emitting = true
	upperArmPhys.gravity_scale = 10
	lowerArmPhys.gravity_scale = 10
	clawPhys.gravity_scale = 10
	if !Global.tutorialsCompleted[3]:
		firstDestroyed.emit()
	
func repaired():
	repairStation.visible=false
	functional = true
	sparks.emitting = false
	upperArmPhys.gravity_scale = 0
	lowerArmPhys.gravity_scale = 0
	clawPhys.gravity_scale = 0
	Global.tutorialsCompleted[3] = true
