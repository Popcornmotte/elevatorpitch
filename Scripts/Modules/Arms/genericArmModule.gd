extends Node2D
class_name GenericArmModule

var claw : Claw
var active = false

func _ready():
	var parent = get_parent()
	while !(parent is Claw) and parent != null:
		parent = parent.get_parent()
	if !parent:
		print("Arm module couldn't find parent")
	else:
		claw = parent

func _process(delta):
	if claw.controlled and claw.arm.functional:
		if Input.is_action_just_pressed("SecondaryAction"):
			activate()
		if active and Input.is_action_just_released("SecondaryAction"):
			deactivate()
	elif active:
		deactivate()

func activate():
	pass
	
func deactivate():
	pass
