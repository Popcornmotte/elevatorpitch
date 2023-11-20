extends Area2D

var collided=false
@export var playerBody:Node2D

# make sure that the player has to keep up or down pressed to keep on climbing
func _process(delta):
	if collided and Input.is_action_pressed("up"):
		playerBody.climbing=true
	elif collided and Input.is_action_pressed("down"):
		playerBody.climbing=true
	else:
		playerBody.climbing=false
		

func _on_body_entered(body):
	if body.name=="player" :
		collided=true
			

func _on_body_exited(body):
	if body.name=="player":
		collided=false
