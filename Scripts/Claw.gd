extends RigidBody2D
class_name Claw

var grabbing = false
var grabbable
var flingTargetDir : Vector2
var aboutToFling = false
var flinging = false
var maxFlingVelocity = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func grab():
	if grabbable != null:
		grabbing = true
		grabbable.grab($GrabArea)
	pass

func release():
	if grabbable != null:
			grabbable.release(self.linear_velocity)
			grabbable = null
			grabbing = false

func setFlingTargetDir(dir : Vector2):
	flingTargetDir = dir

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grabbing:
		grabbable.rotation = rotation
	
	if Input.is_action_pressed("Grab"):
		$ClawSprite.play("close")
	else:
		$ClawSprite.play("open")
	
	if(Input.is_action_just_pressed("Fling") && grabbing):
		aboutToFling = true
	if(Input.is_action_just_released("Fling") && aboutToFling):
		aboutToFling = false
		flinging = true
	if(Input.is_action_just_pressed("Grab")):
		grab()
	if(Input.is_action_just_released("Grab") && !aboutToFling):
		release()
	if Input.is_action_just_pressed("Debug"):
		print("Claw's current grabbable: "+str(grabbable))

	if(flinging && linear_velocity.normalized().dot(flingTargetDir.normalized()) > 0.9):
		maxFlingVelocity = max(maxFlingVelocity, linear_velocity.length())
		if(linear_velocity.length() < maxFlingVelocity):
			maxFlingVelocity = 0.0
			flinging = false
			release()

func _on_grab_area_body_entered(body):
	if grabbable == null && body.has_method("grab"):
		grabbable = body
	pass # Replace with function body.


func _on_grab_area_body_exited(body):
	if(!grabbing):
		grabbable = null
	pass # Replace with function body.
