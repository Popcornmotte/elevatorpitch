extends Node2D


@export var interactionWith : Node2D
@export var sprite : Node2D
@onready var dropeZoneRight=get_node("../DropZoneRight")
@onready var dropeZoneLeft=get_node("../DropZoneLeft")
var collided=false
var newFuel=0

func _interact_with_dropZones():
	newFuel=dropeZoneRight._return_fuel_count()+dropeZoneLeft._return_fuel_count()
	dropeZoneRight._remove_fuel()
	if Global.elevator:#make sure that elevator exists, so that the interior scene can still be used for debugging
		Global.elevator.fuel+=newFuel
		print("Updated fuel: ",Global.elevator.fuel)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if collided and Input.is_action_just_pressed("interact"):
		print("interact")# here the .use function of the corresponding object should be called
		_interact_with_dropZones()

func _on_area_2d_body_entered(body):
	if body.name == "player":
		collided=true


func _on_area_2d_body_exited(body):
	if body.name == "player":
		collided=false



