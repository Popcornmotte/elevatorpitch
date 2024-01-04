extends Node2D
class_name ArmModuleHandler

enum MODULE {Flamethrower, Arclight}

const flamethrower = preload("res://Scenes/Objects/Modules/Arms/flamethrower.tscn")
const arclightProjector = preload("res://Scenes/Objects/Modules/Arms/arclightProjector.tscn")

@export var active = true
@export var left = false
var moduleSelected = true
var module : GenericArmModule
@onready var shield = $Shield
var claw : Claw

func _ready():
	if !active:
		call_deferred("queue_free")
		return
	shield.parent = self
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
		MODULE.Arclight:
			module = arclightProjector.instantiate()
	
	add_child(module)
	module.parent = self
	module.global_position = global_position
	module.rotation = rotation
	
	module.selected = moduleSelected
	shield.selected = !moduleSelected
	
	if left:
		module.flipSprite()
		shield.flipSprite()

func _process(delta):
	if Input.is_action_just_pressed("ScrollUp") or Input.is_action_just_pressed("ScrollDown"):
		moduleSelected = !moduleSelected
		module.selected = moduleSelected
		module.visible = moduleSelected
		shield.selected = !moduleSelected
		$Text.text = "Module" if moduleSelected else "Shield"
		# TODO: visualise which one is active
	pass
