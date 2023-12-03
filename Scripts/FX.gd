extends Node2D

const FX_PLAYER = preload("res://Scenes/Objects/generic_fx.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func playFX(fxName : String, position : Vector2):
	var fxPlayer = FX_PLAYER.instantiate()
	fxPlayer.global_position = position
	add_child(fxPlayer)
	fxPlayer.playFX(fxName)
	pass
