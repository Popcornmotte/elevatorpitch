extends Node2D

const SPEED = 300
const CHAIN_LENGTH = 1000
@onready var Hook = $Hook
var hooked = false
var hookPos : Vector2
var shooting = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset():
	$Hook/HookSprite.self_modulate = Color.WHITE
	Hook.gravity_scale = 0.1
	Hook.linear_velocity = Vector2(0.0,0.0)
	Hook.position = Vector2(0.0,0.0)
	hooked = false
	shooting = false
	Hook.freeze = false

func shoot(pos):
	reset()
	hooked = false
	shooting = true
	Hook.linear_velocity = global_position.direction_to(pos).normalized() * SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$Chain.points[0] = global_position - get_parent().global_position
	$Chain.points[1] = Hook.global_position - get_parent().global_position
	
	if hooked:
		Hook.global_position = hookPos
	
	if(position.distance_to(Hook.position)>CHAIN_LENGTH):
		reset()
	pass


func _on_hook_body_entered(body):
	print("HOOOOKING")
	Hook.linear_velocity = Vector2()
	Hook.angular_velocity = 0
	hooked = true
	Hook.freeze = true
	Hook.gravity_scale = 0
	hookPos = Hook.global_position
	$Hook/HookSprite.self_modulate = Color.BLACK
	get_parent().hook(hookPos)
	pass # Replace with function body.
