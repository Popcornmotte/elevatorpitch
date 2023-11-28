extends RigidBody2D

var connected=false
var collided=false
var dropZone=false
@export var lerpSpeed=5
@onready var lerpTarget= get_node("../player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func attach():
	#make sure player does not collide with dragged fuel
	set_collision_layer_value(5,false)
	gravity_scale=0#otherwise we bang onto the floor when disconnecting
	connected=true
		
func disattach():
	#undo connection
	set_collision_layer_value(1,true)
	gravity_scale=1
	connected=false
	if dropZone:#dropped in dropZome, dont make player collide with the fuel anymore
			set_collision_layer_value(1,false)
		
# this function ensures that the object has to interacted with in its range 
func manageConnection():
	if not connected and collided and Input.is_action_just_pressed("interact"):
		attach()
	elif connected and Input.is_action_just_pressed("interact"):
		disattach()


func _process(delta):
	manageConnection()
	if connected:
		global_position=global_position.lerp(lerpTarget.global_position,delta*lerpSpeed)



func _on_area_2d_body_entered(body):
	if body.name=="player":
		collided=true
		lerpTarget=body.get_node("target")
	if body.name=="DropZone":
		dropZone=true

func _on_area_2d_body_exited(body):
	if body.name=="player":
		collided=false
	if body.name=="DropZone":
		dropZone=false
