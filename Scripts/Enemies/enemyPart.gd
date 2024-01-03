extends Node2D
class_name EnemyPart

var parent : Enemy

@export var mass = 1.0
@export var drag = 0.0
@export var acceleration = 0.0
@export var destroyOnGrab = false
@export var parentOnGrab = false

var index = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent().get_parent()
	index = parent.register_part(self)
	
	pass # Replace with function body.

func grab():
	if(destroyOnGrab):
		destroy()
		queue_free()
	pass

func destroy():
	parent.remove_part(self)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
