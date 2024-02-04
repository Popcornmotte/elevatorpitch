extends Node2D
class_name SupportBeam

@export var healPerTimeout = 25
@export var damageBoost = 2.0
var parent : Node2D
var target : Enemy
var type : SupportBox.SUPPORT_TYPE


func _ready():
	match type:
		SupportBox.SUPPORT_TYPE.health:
			$Timer.start()
			$Line2D.material.set_shader_parameter("Modulate", Color(0.1,1.0,0.0,1.0))
		SupportBox.SUPPORT_TYPE.damage:
			$Line2D.material.set_shader_parameter("Modulate", Color(1.0,0.7,0.0,1.0))
			pass # TODO: Add damage modifier to enemy


func _process(delta):
	if target and weakref(target).get_ref():
		$Line2D.points[0] = to_local(parent.global_position)
		$Line2D.points[1] = to_local(target.global_position)
	else:
		onTimeout()

func onTimeout():
	if target and weakref(target).get_ref() and !target.dead:
		target.takeDamage(-healPerTimeout, 0)
	else:
		parent.get_parent().targetDied(self)
	
