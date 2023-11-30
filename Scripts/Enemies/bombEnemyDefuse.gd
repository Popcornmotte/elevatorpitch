extends RigidBody2D

var parent : RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	pass # Replace with function body.

func grab(clawA):
	parent.defuse()
	pass
	
func release(linVel):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
