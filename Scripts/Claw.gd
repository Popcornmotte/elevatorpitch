extends RigidBody2D
class_name Claw

var grabbing = false
var grabbables : Array
var grabbed
var flingTargetDir : Vector2
var aboutToFling = false
var flinging = false
var maxFlingVelocity = 0.0
var maxFlingAlignment = 0.0
var arm : PhysicalArm
var flingAccFac = 2.0
var controlled = false
var target : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var node = get_parent()
	while !(node is PhysicalArm) && node.get_parent() != null:
		node = node.get_parent()
	arm = node
	arm.claw = self
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
				vector = global_position.direction_to(target.global_position) * vector.length()
			grabbed.release(vector)
			grabbed = null
			grabbing = false
			$ClawSprite.play("open")

func setFlingTargetDir(dir : Vector2):
	flingTargetDir = dir

func setControlled(value : bool):
	if value != controlled:
		controlled = value
		arm.setControlled(controlled)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grabbing:
		if(grabbed == null):
			grabbing = false
		else:
			grabbed.rotation = rotation
	
	if (controlled and Input.is_action_pressed("Grab")) or grabbing or aboutToFling or flinging:
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
	if(Input.is_action_just_released("Grab") and !(aboutToFling or flinging)):
		release()
#	if Input.is_action_just_pressed("Debug"):
#		print("Claw's current grabbable: "+str(grabbable))
	
	var flingAlignment = linear_velocity.normalized().dot(flingTargetDir.normalized())
	#var maxFlingAlignment = max(maxFlingAlignment, flingAlignment)
	if(flinging and flingAlignment > 0.9):
		maxFlingVelocity = max(maxFlingVelocity, linear_velocity.length())
		if(linear_velocity.length() < max(500,maxFlingVelocity) or global_position.distance_to(target.global_position) < 50):
			maxFlingVelocity = 0.0
			flinging = false
			arm.acceleration /= flingAccFac
			release(true)

func _on_grab_area_body_entered(body):
	if body.visible and body.has_method("grab"):
		grabbables.push_back(body)
		#print(body.name + " in reach of " + ("left" if arm.left else "right") + " claw")
	pass # Replace with function body.


func _on_grab_area_body_exited(body):
	grabbables.erase(body)
	pass # Replace with function body.

func disableArm():
	arm.disable()
	pass
