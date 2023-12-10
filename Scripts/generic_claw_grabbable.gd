extends RigidBody2D

var grabbed = false
var claw : Node2D
@onready var originalParent = get_parent()

func grab(clawA):
	grabbed = true
	claw = clawA
	#clawA.add_child(self)

func release(velocity):
	grabbed = false
	global_position = claw.global_position
	claw = null
	linear_velocity = velocity
	#originalParent.add_child(self)
	
func _physics_process(delta):
	if(grabbed):
		global_position = claw.global_position
