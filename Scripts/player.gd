extends CharacterBody2D


@export var speed = 200.0
@export var climbSpeed=100.0
@export var jumpVelocity = -300.0
@export var maxFallingSpeed=500.0 #this should not be relevant, but cap at which body does not accelerate any more when falling
@export var climbing=false #variable set when interacting with ladder to indicate climb
@export var pushForce=80.0 #relevant when colliding with other rigidbodies


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _flip_animation(direction):
	if direction>0:
		$AnimatedSprite2D.flip_h=false
	else:
		$AnimatedSprite2D.flip_h=true
		
func _jump(direction):
	#jumping only allowed when on floor and space bar pressed
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpVelocity
	
# Function that needs to be called after move and slide to provide collision with rigidbodies
func _collide_with_rigidbodies():
	for i in get_slide_collision_count():
		var c=get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal()*pushForce)
			
func _move(direction):
	if direction:
		if is_on_floor():
			#flip animation if necessary
			$AnimatedSprite2D.play("walk")
			_flip_animation(direction)
		#allow the player to also move mid jump
		velocity.x = direction * speed
	else:
		if is_on_floor():
			$AnimatedSprite2D.play("idle")
		velocity.x = move_toward(velocity.x, 0, speed)

	

func _fall(direction,delta):
	velocity.y += gravity * delta
	$AnimatedSprite2D.play("jump")
	_flip_animation(direction)
	#cap falling speed
	if velocity.y>maxFallingSpeed:
		velocity.y=maxFallingSpeed

func _climb(direction):
	velocity.y=0
	$AnimatedSprite2D.play("climb")
	if Input.is_action_pressed("up"):
		velocity.y=-speed
	elif Input.is_action_pressed("down"):
		velocity.y=speed
		

			
func _physics_process(delta):
	#direction is used to flip animations accordingly
	var direction = Input.get_axis("left", "right")
	if not climbing and not is_on_floor():
		_fall(direction,delta)
	elif climbing:
		_climb(direction)
	_jump(direction)
	_move(direction)
	move_and_slide()
	_collide_with_rigidbodies()
	
