extends Node2D
var potential_body:Node2D #entering fuel that has to be dropped off
var collided=false
var fuel=[]
func _process(delta):
	pass
func _remove_fuel():
	for item in fuel:
		item.free()


func _return_fuel_count():
	return fuel.size()
func _on_area_2d_body_entered(body):
	print(body.get_name())
	if body.is_in_group("fuel"):
		collided=true
		potential_body=body
		fuel.append(body)
func _on_area_2d_body_exited(body):
	if body.is_in_group("fuel"):
		collided=false
		fuel.remove_at(fuel.size()-1)
