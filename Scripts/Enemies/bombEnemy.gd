extends RigidBody2D

@export var maxSpeed = 50

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
	explode()

func release(linVel):
	pass

#make sure to set collision mask and layer in a way
#that only elevator parts are registered
func onTriggerAreaEnter(other):
	explode()

func explode():
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
	pass
