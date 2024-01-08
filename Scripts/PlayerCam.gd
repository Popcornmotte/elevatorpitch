extends Camera2D


@export var deadZoneLimit : float = 350.0
var deadZone = 2000

func setMousePeek(state):
	if state:
		deadZone = deadZoneLimit
	else:
		deadZone = 2000

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var target = event.position - get_viewport().size * 0.5
		if target.length() < deadZone:
			position = Vector2(0,0)
		else:
			position = target.normalized() * (target.length() -  deadZone) * 0.5
