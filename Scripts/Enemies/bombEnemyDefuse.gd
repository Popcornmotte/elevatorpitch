extends ClawGrabbable

var parent : RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	pass # Replace with function body.

func grab(clawA):
	if parent and weakref(parent).get_ref():
		parent.defuse()
		$SpriteWithRope.visible = false
		$SpriteWithoutRope.visible = true
	super(clawA)
	pass
