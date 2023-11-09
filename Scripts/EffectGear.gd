extends Sprite2D

#This needs to be the node that actually rotates. Could be the sprite itself,
#but could actually also be e.g. the Bone2D that the target sprite is attachted to
@export var TargetGear : Node2D 


func _process(delta):
	rotation = - TargetGear.rotation

