extends GenericDestroyable
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
var upperArmMass = 0.0
var lowerArmMass = 0.0
var clawMass = 0.0

var aimClaw = false

# Called when the node enters the scene tree for the first time.
func _ready():
	upperArmPhys = find_child("UpperArm")
	upperArmMass = upperArmPhys.mass
	lowerArmPhys = find_child("LowerArm")
	lowerArmMass = lowerArmPhys.mass
	clawPhys = find_child("Claw")
	clawMass = clawPhys.mass
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
		if !aimClaw:
			rotatePart(delta, clawPhys, clawRef)
		else:
			var angle = upperArmPhys.global_position.direction_to(clawPhys.global_position).angle()
			var diff = angle_difference(clawPhys.global_rotation, angle)
			clawPhys.angular_velocity = diff * acceleration * delta
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
	repairStation.enableRepair()
	functional = false
	sparks.emitting = true
	upperArmPhys.gravity_scale = 1
	upperArmPhys.mass = 10
	lowerArmPhys.gravity_scale = 1
	lowerArmPhys.mass = 10
	clawPhys.gravity_scale = 1
	clawPhys.mass = 10
	Global.elevator.newBrokenModule()
	if !Global.tutorialsCompleted[3]:
		firstDestroyed.emit()

func damaged():
	repairStation.visible=true
	repairStation.enableOptionalRepair()
	sparks.emitting = true
	if !Global.tutorialsCompleted[3]:
		firstDestroyed.emit()
		
func repaired():
	repairStation.visible=false
	functional = true
	sparks.emitting = false
	upperArmPhys.gravity_scale = 0
	upperArmPhys.mass = upperArmMass
	lowerArmPhys.gravity_scale = 0
	lowerArmPhys.mass = lowerArmMass
	clawPhys.gravity_scale = 0
	clawPhys.mass = clawMass
	Global.tutorialsCompleted[3] = true
