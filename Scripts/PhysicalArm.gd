extends Node2D

var upperArmPhys : RigidBody2D
var lowerArmPhys : RigidBody2D

@export var upperArmRef : Bone2D
@export var lowerArmRef : Bone2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	upperArmPhys = find_child("UpperArm")
	lowerArmPhys = find_child("LowerArm")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#upperArmPhys.angular_velocity -= upperArmPhys.rotation - upperArmRef.rotation
	#lowerArmPhys.angular_velocity += lowerArmPhys.rotation - lowerArmRef.rotation
	
	pass
