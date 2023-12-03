extends Node2D

@export var maxCloudHeight = 30
var currentHeight = Global.height
var children : Array[CustomParallaxLayer]

# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_children():
		if node is CustomParallaxLayer:
			children.push_back(node)
			node.maxCloudHeight = maxCloudHeight
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
