extends Node


#This Object is to be frequently edited to let debug key do whatever is currently
#needed for debugging.


func _ready():
	pass 



func _process(delta):
	if Input.is_action_just_pressed("Debug"):
		Global.addToInventory(Item.new(Item.TYPE.Cargo))
	pass
