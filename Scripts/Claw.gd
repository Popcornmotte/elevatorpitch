extends RigidBody2D

var grabbing = false
var grabbable

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func grab():
	if grabbable != null:
		grabbing = true
		grabbable.grab($GrabArea)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grabbing:
		grabbable.rotation = rotation
	
	if Input.is_action_pressed("Grab"):
		$ClawSprite.play("close")
	else:
		$ClawSprite.play("open")
		
	if(Input.is_action_just_pressed("Grab")):
		grab()
	if(Input.is_action_just_released("Grab")):
		if grabbable != null:
			grabbable.release(self.linear_velocity)
			grabbable = null
			grabbing = false
	if Input.is_action_just_pressed("Debug"):
		print("Claw's current grabbable: "+str(grabbable))


func _on_grab_area_body_entered(body):
	if grabbable == null && body.has_method("grab"):
		grabbable = body
	pass # Replace with function body.


func _on_grab_area_body_exited(body):
	if(!grabbing):
		grabbable = null
	pass # Replace with function body.
