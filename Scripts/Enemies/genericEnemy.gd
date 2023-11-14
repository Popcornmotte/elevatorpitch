extends RigidBody2D
class_name GenericEnemy

var target = Vector2(425,360) # elevator coords
var minRadius = 250.0
var maxVel = 50.0
var acc = 0.0

var facing = 0.0
var wobbleAmp = 0.125
var wobbleSpeed = 2.0
var time = 0.0

var parts = []
var drag = 0.0

var projectile = preload("res://Scenes/Objects/Enemies/projectileBullet.tscn")
var shootFreq = 5.0 # projectiles per second
var shootCooldown = 0
var shootDist = 400.0 # distance to start shooting at

var debug : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	debug = find_child("DebugMarker")
	shootCooldown = 1.0/shootFreq
	pass # Replace with function body.

func register_part(part : EnemyPart):
	var index = parts.size()
	parts.push_back(part)
	mass += part.mass
	drag += part.drag
	acc += part.acceleration
	return index
	
func remove_part(part : EnemyPart):
	parts.remove_at(part.index)
	mass -= part.mass
	drag -= part.drag
	acc -= part.acceleration
	pass

func grab(): # call this when grabbing this enemy
	pass
	
func release(): # call this when releasing this enemy
	pass



func move(delta):
	
	var speedModifier = clamp((target.distance_to(global_position) - minRadius) / 800.0, 0, 1)
	
	facing = sin(time * wobbleSpeed) * wobbleAmp * PI
	var forward = (target - global_position).normalized() * acc
	forward = forward.rotated(facing)
	
	debug.global_position = global_position + (forward / acc) * 50
	
	linear_velocity += forward
	var speed = linear_velocity.length()
	linear_velocity = linear_velocity.normalized() * min(speed * speedModifier, maxVel)
	linear_velocity += Vector2(0,-9.81) * mass
	
	angular_velocity -= rotation * 3 * delta
	
	pass
	
func shoot(delta):
	shootCooldown -= delta
	if(target.distance_to(global_position) >= shootDist or shootCooldown > 0):
		return
	
	var forward = (target - global_position).normalized()
	
	var bullet = projectile.instantiate()
	bullet.get_child(0).velocity = linear_velocity + forward * 1000.0
	bullet.get_child(0).position = global_position
	get_parent().get_parent().add_child(bullet)
	
	shootCooldown = 1.0/shootFreq
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if(time > 2 * PI): time -= 2 * PI
	move(delta)
	shoot(delta)
	pass
