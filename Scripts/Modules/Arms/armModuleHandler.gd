extends Node2D
class_name ArmModuleHandler

enum MODULE {None, Flamethrower, Arclight}

const flamethrower = preload("res://Scenes/Objects/Modules/Arms/flamethrower.tscn")
const arclightProjector = preload("res://Scenes/Objects/Modules/Arms/arclightProjector.tscn")

const extensionSFX = preload("res://Assets/Audio/sfx/modules/moduleExtend.wav")
const retractionSFX = preload("res://Assets/Audio/sfx/modules/moduleRetract.wav")

@export var active = true
@export var left = false
var moduleSelected = false
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
	
	if module:
		$MaskingGroup/AnimationParent.add_child(module)
		module.parent = self
		module.global_position = $MaskingGroup/AnimationParent.global_position
		module.rotation = rotation
		
		module.selected = moduleSelected
	shield.selected = !moduleSelected or !module
	
	if left:
		if module:
			module.flipSprite()
		shield.flipSprite()

func _process(delta):
	if module:
		var moduleSelectedPrev = moduleSelected
		if (Input.is_action_just_pressed("ScrollUp") or Input.is_action_just_pressed("ScrollDown")):
			moduleSelected = !moduleSelected
		if Input.is_action_just_pressed("SelectShield"):
			moduleSelected = false
		if Input.is_action_just_pressed("SelectModule"):
			moduleSelected = true
		
		if moduleSelectedPrev != moduleSelected:
			module.selected = moduleSelected
			if moduleSelected:
				module.visible = true
			shield.selected = !moduleSelected
			$Extension.play("extend_module" if moduleSelected else "retract_module")
			Audio.playSfxLocalized(extensionSFX if moduleSelected else retractionSFX, global_position)
			$Text.text = "Module" if moduleSelected else "Shield"
			# TODO: visualise which one is active
	pass

func _on_extension_animation_finished(anim_name):
	if !moduleSelected:
		module.visible = false
