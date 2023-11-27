extends RigidBody2D

var connected=false
var collided=false
@export var lerpSpeed=5
@onready var lerpTarget= get_node("../player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _connect():
	#make sure player does not collide with dragged fuel
	set_collision_layer_value(5,false)
	gravity_scale=0#otherwise we bang onto the floor when disconnecting
	connected=true
		
func _disconnect():
	#undo connection
	set_collision_layer_value(1,true)
	gravity_scale=1
	connected=false
# this function ensures that the object has to interacted with in its range 
func _manage_connection():
	if not connected and collided and Input.is_action_just_pressed("interact"):
		_connect()
	elif connected and Input.is_action_just_pressed("interact"):
		_disconnect()


func _process(delta):
	_manage_connection()
	if connected:
		global_position=global_position.lerp(lerpTarget.global_position,delta*lerpSpeed)



func _on_area_2d_body_entered(body):
	if body.name=="player":
		collided=true
		lerpTarget=body.get_node("target")

func _on_area_2d_body_exited(body):
	if body.name=="player":
		collided=false
		
