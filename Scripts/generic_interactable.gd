extends Node2D


@export var interactionWith : Node2D
@export var sprite : Node2D
var collided=false
@onready var player=get_node("../player")

func interact():
	pass
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not player:# ugly fix for instantiated objects that dont show up otherwise:/
		player=get_node("../../player")
	if collided and Input.is_action_just_pressed("interact") and not player.carrying:
		print("interact: ",player.carrying)# here the .use function of the corresponding object should be called
		interact()

func _on_area_2d_body_entered(body):
	#player=body
	if body.name == "player":
		collided=true


func _on_area_2d_body_exited(body):
	if body.name == "player":
		collided=false



