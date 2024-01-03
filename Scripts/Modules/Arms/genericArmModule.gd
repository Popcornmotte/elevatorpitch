extends Node2D
class_name GenericArmModule

var parent : ArmModuleHandler
var active = false
var selected = true

func _process(delta):
	if parent and parent.claw.controlled and parent.claw.arm.functional and selected:
		if Input.is_action_just_pressed("RightClick"):
			activate()
		if active and Input.is_action_just_released("RightClick"):
			deactivate()
	elif active:
		deactivate()

func activate():
	pass
	
func deactivate():
	pass
