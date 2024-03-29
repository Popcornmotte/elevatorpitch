extends Node2D

@export var atmosphere : Sprite2D
@onready var stationPos = $ParallaxBackground/CableLayer/Station.global_position
var stationSpawned = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#layers = parallax.get_children()
	pass # Replace with function body.

func switchNight(night : bool):
	if night:
		$ParallaxBackground/EarthLayer.hide()
		#$FarBackground.hide()
		$FarBackground/Atmosphere.hide()
		$ParallaxBackground/CloudsLayer0.hide()
		$ParallaxBackground/CloudsLayer1.hide()
	else:
		$ParallaxBackground/EarthLayer.show()
		#$FarBackground.show()
		$FarBackground/Atmosphere.show()
		$ParallaxBackground/CloudsLayer0.show()
		$ParallaxBackground/CloudsLayer1.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	atmosphere.material.set_shader_parameter("Height", Global.height)
	
	if Global.level and Global.height > (Global.level.finishHeight - 2) and !stationSpawned:
		$ParallaxBackground/CableLayer/Station.global_position = stationPos
		$ParallaxBackground/CableLayer/Station.visible = true
		stationSpawned = true
	pass
