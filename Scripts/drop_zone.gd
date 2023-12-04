extends Node2D
var potential_body:Node2D #entering fuel that has to be dropped off
var collided=false
var fuel=[]
func _process(delta):
	pass
func _remove_fuel():
	while not fuel.is_empty(): 
		var item = fuel.pop_back()
		item.queue_free()
	fuel.clear()

func _return_fuel_count():
	return fuel.size()
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("fuel"):
		collided=true
		potential_body=body
		fuel.push_back(body)

func _on_area_2d_body_exited(body):
	if body.is_in_group("fuel"):
		collided=false
		fuel.remove_at(fuel.size()-1)
