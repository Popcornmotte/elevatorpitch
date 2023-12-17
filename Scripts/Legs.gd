extends Sprite2D

@export var movementFactor=1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.elevator.moving:
		$wheelL.rotation += 5*delta
		$wheelR.rotation -= 5*delta
		for child in $Cable.get_children():
			child.global_position.y += 40*delta
			if child.global_position.y >= 960:
				child.global_position.y = -120
		Global.elevator.decrease_fuel(delta * 0.1)
		Global.height += delta*movementFactor
	pass
