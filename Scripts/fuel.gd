extends RigidBody2D

var connected=false
var connectTo:Node2D
var speed=5
var target:Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if connected:
		var distance=Vector2()
		distance=global_position-target.global_position
		print(distance.length())
		global_position=global_position.lerp(target.global_position,delta*speed)



func _on_area_2d_body_entered(body):
	if body.name == "player":
		print("follow")
		target=body.get_node("target")
		set_collision_layer_value(1,false)
		connected=true

func _on_area_2d_body_exited(body):
	if body.name=="player":
		print("not follow")
