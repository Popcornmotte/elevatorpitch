extends Node2D

@export var atmosphere : Sprite2D
@export var parallax : ParallaxBackground

@export var maxCloudHeight = 30

var layers : Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready():
	layers = parallax.get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	atmosphere.material.set_shader_parameter("Height", Global.height)
	parallax.scroll_base_offset.y = Global.height * 100
	for layer in layers:
		for child in layer.get_children():
			var respawn = true
			respawn = respawn && !layer.is_in_group("Earth")
			respawn = respawn && (!layer.is_in_group("Clouds") or Global.height <= maxCloudHeight)
			if respawn && (child.global_position.y > 1000):
				child.global_position.y -= 2000
				#print("Respawned " + child.name)
	pass
