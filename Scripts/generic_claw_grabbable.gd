extends RigidBody2D
class_name ClawGrabbable

var grabbed = false
var claw : Node2D
@onready var originalParent = get_parent()
@export var isItem = false
@export var item : Item

func grab(clawA):
	grabbed = true
	claw = clawA

func release(velocity):
	
	grabbed = false
	if claw:
		position = claw.global_position
	claw = null
	linear_velocity = velocity
	
func _integrate_forces(state):
	if(grabbed):
		global_position = claw.global_position

