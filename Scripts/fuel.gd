extends RigidBody2D

var connected=false
var connectTo:Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	if connected:
		draw_line(position,connectTo.position,Color(1.0, 0.0, 0.0))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()



func _on_area_2d_body_entered(body):
	if body.name == "player":
		print("follow")
		var node=DampedSpringJoint2D.new()
		node.set_node_a(get_path())
		node.set_node_b(body.get_path())
		connectTo=body
		node.stiffness=10
		node.length=20
		add_child(node)
		set_collision_layer_value(1,false)
		connected=true

func _on_area_2d_body_exited(body):
	if body.name=="player":
		print("not follow")
