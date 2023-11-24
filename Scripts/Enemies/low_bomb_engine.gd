extends DeleteSelf

# Called when the node enters the scene tree for the first time.
func _ready():
	self.angular_velocity = randf_range(-3,3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	self.linear_velocity += Vector2(0,-100 * delta).rotated(rotation)
	pass
