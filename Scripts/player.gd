extends CharacterBody2D


@export var SPEED = 200.0
@export var JUMP_VELOCITY = -300.0
@export var climbing=false
@export var pushForce=80.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _jump():
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
# Function that needs to be called after move and slide to provide collision with rigidbodies
func _collide_with_rigidbodies():
	for i in get_slide_collision_count():
		var c=get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal()*pushForce)
			
func _move():
	var direction = Input.get_axis("left", "right")
	if direction:
		if is_on_floor():
			if direction>0:
				$AnimatedSprite2D.play("walk")
				$AnimatedSprite2D.flip_h=false
			else:
				$AnimatedSprite2D.play("walk")
				$AnimatedSprite2D.flip_h=true
		velocity.x = direction * SPEED
	else:
		if is_on_floor():
			$AnimatedSprite2D.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	
func _physics_process(delta):
	# Add the gravity.
	if not climbing and not is_on_floor():
		velocity.y += gravity * delta
		$AnimatedSprite2D.play("jump")		
		if velocity.y>500:
			velocity.y=500
	elif climbing:
		velocity.y=0
		if Input.is_action_pressed("up"):
			velocity.y=-SPEED
		elif Input.is_action_pressed("down"):
			velocity.y=SPEED
	_jump()
	_move()
	_collide_with_rigidbodies()
	
