extends Node2D


@export var interactionWith : Node2D
@export var sprite : Node2D

var collided=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if collided and Input.is_action_just_pressed("interact"):
		print("interact")# here the .use function of the corresponding object should be called
		if is_instance_valid(interactionWith):
			interactionWith._use()

func _on_area_2d_body_entered(body):
	if body.name == "player":
		
		collided=true


func _on_area_2d_body_exited(body):
	if body.name == "player":
		collided=false
