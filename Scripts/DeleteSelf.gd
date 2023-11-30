extends Node2D
class_name DeleteSelf

## REMEMBER TO CALL super._process(delta) IF YOU INHERIT FROM THIS

## Time until self destruct. Set negative to disable timer
@export var time_to_death = -1.0

## Maximum bounds, from -x to +x and -y to +y. Self destruct if outside of bounds.
@export var max_bounds = Vector2(1500,1000)

func _process(delta):
	if(time_to_death >= 0):
		time_to_death -= delta
		if(time_to_death < 0):
			queue_free()
	
	if(abs(global_position.x) > max_bounds.x or abs(global_position.y) > max_bounds.y):
		queue_free()
	pass
