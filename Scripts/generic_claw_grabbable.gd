extends RigidBody2D
class_name ClawGrabbable

var grabbed = false
var claw : Node2D
@onready var originalParent = get_parent()
@export var isItem = false
@export var item : Item.TYPE

func grab(clawA):
	grabbed = true
	claw = clawA

func set_enabled(state):
	if state:
		show()
		$colShape.disabled = false
	else:
		hide()
		$colShape.disabled = true

func release(velocity):
	
	grabbed = false
	if claw:
		position = claw.global_position
	claw = null
	linear_velocity = velocity
	
func _integrate_forces(state):
	if(grabbed):
		global_position = claw.global_position

