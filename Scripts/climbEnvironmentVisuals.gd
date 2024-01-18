extends Node2D

@export var atmosphere : Sprite2D
@onready var stationPos = $ParallaxBackground/CableLayer/Station.global_position
var stationSpawned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#layers = parallax.get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	atmosphere.material.set_shader_parameter("Height", Global.height)
	
	if Global.height > (Global.level.finishHeight - 1) and !stationSpawned:
		$ParallaxBackground/CableLayer/Station.global_position = stationPos
		$ParallaxBackground/CableLayer/Station.visible = true
		stationSpawned = true
	pass
