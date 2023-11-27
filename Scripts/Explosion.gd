extends DeleteSelf

@export var damage = 10.0

func onAreaEntered(other : Node2D):
	if other.has_method("takeDamage"):
		var distanceFactor = global_position.distance_to(other.global_position)
		distanceFactor = 1/(distanceFactor+1)
		other.takeDamage(damage * distanceFactor)
