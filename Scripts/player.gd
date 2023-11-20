extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0
@onready var anim=get_node("AnimatedSprite2D")
var interactable=false
@export var climbing=false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _unhandled_input(event):
	if event.is_action_pressed("interact") and interactable:
		print("control arms")

func _physics_process(delta):
	# Add the gravity.
	if not climbing and not is_on_floor():
		velocity.y += gravity * delta
		anim.play("jump")		
		if velocity.y>500:
			velocity.y=500
	elif climbing:
		velocity.y=0
		if Input.is_action_pressed("up"):
			velocity.y=-SPEED
		elif Input.is_action_pressed("down"):
			velocity.y=SPEED
		

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = Input.get_axis("a", "d")
	if direction:
		if is_on_floor():
			if direction>0:
				anim.play("walk")
				$AnimatedSprite2D.flip_h=false
			else:
				anim.play("walk")
				$AnimatedSprite2D.flip_h=true
		velocity.x = direction * SPEED
	else:
		if is_on_floor():
			anim.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_area_2d_area_entered(area):
	if area.is_in_group("ArmStation"):
		interactable=true


func _on_area_2d_area_exited(area):
	if interactable:
		interactable=false
