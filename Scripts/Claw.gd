extends RigidBody2D
class_name Claw

var grabbing = false
var grabbables : Array
var grabbed
var flingTargetDir : Vector2
var aboutToFling = false
var flinging = false
var maxFlingVelocity = 0.0
var arm : PhysicalArm
var flingAccFac = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var node = get_parent()
	while !(node is PhysicalArm) && node.get_parent() != null:
		node = node.get_parent()
	arm = node
	pass # Replace with function body.

func grab():
	if grabbables.size() > 0:
		grabbing = true
		grabbed = grabbables.back()
		grabbables.back().grab($GrabArea)
	pass

func release(fling = false):
	if grabbed != null:
			var vector = self.linear_velocity
			if fling:
				vector = flingTargetDir.normalized() * vector.length()
			grabbed.release(vector)
			grabbed = null
			grabbing = false

func setFlingTargetDir(dir : Vector2):
	flingTargetDir = dir

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grabbing:
		if(grabbed == null):
			grabbing = false
		else:
			grabbed.rotation = rotation
	
	if Input.is_action_pressed("Grab") or aboutToFling or flinging:
		$ClawSprite.play("close")
	else:
		$ClawSprite.play("open")
	
	if(Input.is_action_just_pressed("Fling") && grabbing):
		aboutToFling = true
	if(Input.is_action_just_released("Fling") && aboutToFling):
		aboutToFling = false
		flinging = true
		arm.acceleration *= flingAccFac
	if(Input.is_action_just_pressed("Grab")):
		grab()
	if(Input.is_action_just_released("Grab") && !aboutToFling):
		release()
#	if Input.is_action_just_pressed("Debug"):
#		print("Claw's current grabbable: "+str(grabbable))

	if(flinging && linear_velocity.normalized().dot(flingTargetDir.normalized()) > 0.9):
		maxFlingVelocity = max(maxFlingVelocity, linear_velocity.length())
		if(linear_velocity.length() < maxFlingVelocity):
			maxFlingVelocity = 0.0
			flinging = false
			arm.acceleration /= flingAccFac
			release(true)

func _on_grab_area_body_entered(body):
	if body.has_method("grab"):
		grabbables.push_back(body)
	pass # Replace with function body.


func _on_grab_area_body_exited(body):
	grabbables.erase(body)
	pass # Replace with function body.

func disableArm():
	arm.disable()
	pass
