extends RigidBody2D

@export var pos : Vector2

func _integrate_forces(state):
	position = pos
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pos = position
	pass # Replace with function body.

func move(newPos : Vector2):
	pos =newPos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
