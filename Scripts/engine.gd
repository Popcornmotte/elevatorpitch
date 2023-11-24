extends Node2D

@export var drop_zone:Node2D
@export var fuel_counter=0
func _use():
	fuel_counter+=drop_zone.fuel.size()
	drop_zone._remove_fuel()#remove collected fuel
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
