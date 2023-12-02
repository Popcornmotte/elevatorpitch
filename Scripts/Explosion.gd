extends DeleteSelf

@export var damage = 100.0

func onAreaEntered(other : Node2D):
	if other.has_method("takeDamage"):
		var distanceFactor = global_position.distance_to(other.global_position)/50.0
		distanceFactor = 1/(distanceFactor+1)
		other.takeDamage(damage * distanceFactor)
	elif other.get_parent() != null:
		onAreaEntered(other.get_parent())


func _on_animated_sprite_2d_animation_finished():
	queue_free()
	pass # Replace with function body.
