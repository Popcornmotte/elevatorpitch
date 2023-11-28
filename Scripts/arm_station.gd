extends Node2D


@export var interactionWith : Node2D
@export var sprite : Node2D

var collided=false
var control_arms=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if collided and Input.is_action_just_pressed("interact"):
		control_arms=!control_arms#change whether arms are being controlled or not
		if Global.elevator:# this makes the scene still useable on its own
			Global.elevator.control(control_arms)

func _on_area_2d_body_entered(body):
	if body.name == "player":
		collided=true


func _on_area_2d_body_exited(body):
	if body.name == "player":
		collided=false
