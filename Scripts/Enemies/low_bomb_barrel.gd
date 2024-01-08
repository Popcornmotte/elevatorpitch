extends ClawGrabbable

@onready var elevatorPos = Global.elevator.global_position

func _process(delta):
	if(global_position.distance_to(elevatorPos) > 3000):
		queue_free()
