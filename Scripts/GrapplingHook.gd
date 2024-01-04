extends DampedSpringJoint2D

@onready var ray = $ray
@onready var chain = $chain
var hooked = false
var hookPos : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset():
	hooked = false
	node_b = ""
	length = 0
	chain.points[0] = Vector2()
	chain.points[1] = Vector2()
	

func shoot():
	if ray.is_colliding():
		var collider = ray.get_collider()
		hookPos = ray.get_collision_point()
		var distance = hookPos.distance_to(global_position)
		length = distance
		hooked = true
		node_b = collider.get_path()
		return hookPos
		pass
	return null
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hooked:
		chain.points[0] = global_position - get_parent().global_position
		chain.points[1] = hookPos - get_parent().global_position
	ray.look_at(get_global_mouse_position())
	
	
	pass
