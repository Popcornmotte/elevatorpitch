extends RigidBody2D

@export var maxSpeed = 50
@export var hitPoints = 50
const THUDS = [preload("res://Assets/Audio/sfx/wood_thud0.wav"), preload("res://Assets/Audio/sfx/wood_thud1.wav"), preload("res://Assets/Audio/sfx/wood_thud2.wav")]
const BOOM = preload("res://Assets/Audio/sfx/explosion.wav")

var explosion = preload("res://Scenes/Objects/explosion.tscn")
var engine = preload("res://Scenes/Objects/Enemies/low_bomb_engine.tscn")
var barrel = preload("res://Scenes/Objects/Enemies/low_bomb_barrel.tscn")

var elevatorPos : Vector2
var target : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.aliveEnemies += 1
	elevatorPos = Global.elevator.global_position
	chooseTarget()
	pass

func chooseTarget():
	target = elevatorPos + Vector2(randi_range(50,90),randi_range(-90,90))

func grab(clawA):
	var node = clawA
	while !(node.has_method("disableArm")) && node.get_parent() != null:
		node = node.get_parent()
	if(node.has_method("disableArm")):
		node.disableArm()
	explode()

func release(linVel):
	pass

func takeDamage(damage):
	hitPoints -= damage

func _on_body_entered(body):
	if(body.is_class("RigidBody2D")):
		if (body.linear_velocity - linear_velocity).length() > 500.0:
			hitPoints -= body.mass * (0.1 * body.linear_velocity.length())
			Audio.playSfx(THUDS.pick_random())

func explode():
	Audio.playSfx(BOOM)
	var newExplosion = explosion.instantiate()
	newExplosion.global_position = global_position
	get_parent().call_deferred("add_child",newExplosion)
	
	var newEngine = engine.instantiate()
	newEngine.global_position = global_position
	get_parent().call_deferred("add_child",newEngine)
	
	die()
	pass

func defuse():
	var newEngine = engine.instantiate()
	newEngine.global_position = global_position
	get_parent().call_deferred("add_child",newEngine)
	
	var newBarrel = barrel.instantiate()
	newBarrel.global_position = global_position
	get_parent().call_deferred("add_child",newBarrel)
	
	die()

func die():
	Global.aliveEnemies -= 1
	call_deferred("queue_free")
	

func move(delta):
	angular_velocity = -rotation * 100 * delta
	var direction = global_position.direction_to(target).normalized()
	var speed = lerpf(linear_velocity.length(),maxSpeed,0.5)
	linear_velocity = direction * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	if(hitPoints <= 0):
		explode()
	pass


func _on_trigger_area_entered(area):
	explode()
	pass # Replace with function body.
