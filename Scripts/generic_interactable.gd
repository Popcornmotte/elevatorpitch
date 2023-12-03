extends Node2D

class_name GenericInteractible
@export var interactionWith : Node2D
@export var sprite : Node2D
var collided=false
@onready var player=get_node("../player")

		
func interact():
	pass
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
		if collided and Input.is_action_just_pressed("interact") and not player.carrying:
			print("interact: ",player.carrying)# here the .use function of the corresponding object should be called
			interact()
	else:
		print("no player")
		player=get_parent().get_node("../player")# ugly fix for instantiated objects that dont show up otherwise:/

func _on_area_2d_body_entered(body):
	if body.name == "player":
		collided=true


func _on_area_2d_body_exited(body):
	if body.name == "player":
		collided=false



