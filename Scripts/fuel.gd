extends "res://Scripts/generic_interactable.gd"

var connected=false
var dropZone=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func interact():
	if player.pick_up_object(Item.TYPE.Fuel):# only destroy object if successfully picked up by player
		queue_free()
		
