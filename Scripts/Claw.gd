extends RigidBody2D
class_name Claw

const GRAB = preload("res://Assets/Audio/sfx/clawGrab.wav")
const RELEASE = preload("res://Assets/Audio/sfx/clawRelease.wav")

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
var normalArmAcc = 0.0
var flingArmAcc = 0.0
var controlled = false
var target : Node2D
var grabLocked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var node = get_parent()
	while !(node is PhysicalArm) && node.get_parent() != null:
		node = node.get_parent()
	arm = node
	normalArmAcc = arm.acceleration
	flingArmAcc = arm.acceleration * flingAccFac
	arm.claw = self
	pass # Replace with function body.

func grab():
	if grabbables.size() > 0 and !grabLocked:
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

func setGrabLock(value, shield):
	grabLocked = value
	arm.aimClaw = grabLocked
	if grabLocked:
		release()
	if shield:
		$ClawSprite.play("shield" if grabLocked else "open")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grabbing:
		if(grabbed == null):
			grabbing = false
		else:
			grabbed.rotation = rotation
	
	if !grabLocked:
		if (controlled and Input.is_action_pressed("Grab")) or grabbing or aboutToFling or flinging:
			$ClawSprite.play("close")
		else:
			$ClawSprite.play("open")
	
	if(Input.is_action_just_pressed("Fling") && grabbing):
		aboutToFling = true
	if(Input.is_action_just_released("Fling") && aboutToFling):
		aboutToFling = false
		flinging = true
		arm.acceleration = flingArmAcc
	if !grabLocked and (Input.is_action_just_pressed("Grab")):
		grab()
		if Global.elevator.controlArms:
			Audio.playSfx(GRAB)
	if !grabLocked and (Input.is_action_just_released("Grab") and !(aboutToFling or flinging)):
		release()
		if Global.elevator.controlArms:
			Audio.playSfx(RELEASE)
#	if Input.is_action_just_pressed("Debug"):
#		print("Claw's current grabbable: "+str(grabbable))
	
	var flingAlignment = linear_velocity.normalized().dot(flingTargetDir.normalized())
	#var maxFlingAlignment = max(maxFlingAlignment, flingAlignment)
	if(flinging):
		maxFlingVelocity = max(maxFlingVelocity, linear_velocity.length())
		if(linear_velocity.length() < maxFlingVelocity-10 or global_position.distance_to(target.global_position) < 50):
			print(str(linear_velocity.length()) + " < " + str(maxFlingVelocity))
			maxFlingVelocity = 0.0
			flinging = false
			arm.acceleration = normalArmAcc
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
