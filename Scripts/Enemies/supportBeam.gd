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
		SupportBox.SUPPORT_TYPE.damage:
			pass # TODO: Add damage modifier to enemy


func _process(delta):
	$Line2D.points[0] = parent.global_position - global_position
	$Line2D.points[1] = target.global_position - global_position

func onTimeout():
	target.takeDamage(-healPerTimeout, 0)
