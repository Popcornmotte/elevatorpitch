extends Node2D
class_name ArmModuleHandler

enum MODULE {Flamethrower, Arclight}

const flamethrower = preload("res://Scenes/Objects/Modules/Arms/flamethrower.tscn")
var moduleSelected = true
var module : GenericArmModule
@onready var shield = $Shield
var claw : Claw

func _ready():
	var parent = get_parent()
	while !(parent is Claw) and parent != null:
		parent = parent.get_parent()
	if !parent:
		print("Arm module couldn't find parent")
	else:
		claw = parent
	
	match Global.armModule:
		MODULE.Flamethrower:
			module = flamethrower.instantiate()
	
	add_child(module)
	module.parent = self
	module.global_position = global_position
	module.rotation = rotation

func _process(delta):
	if Input.is_action_just_pressed("ScrollUp") or Input.is_action_just_pressed("ScrollDown"):
		moduleSelected = !moduleSelected
		module.selected = moduleSelected
		shield.selected = !moduleSelected
		$Text.text = "Module" if moduleSelected else "Shield"
		# TODO: visualise which one is active
	pass
