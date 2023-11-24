extends RigidBody2D

@export var maxSpeed = 50

var explosion = preload("res://Scenes/Objects/explosion.tscn")
var engine = preload("res://Scenes/Objects/engine.tscn")
var barrel = preload("res://Scenes/Objects/Enemies/low_bomb_barrel.tscn")

var elevatorPos : Vector2
var target : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	elevatorPos = Global.elevator.global_position
	chooseTarget()
	pass

func chooseTarget():
	target = elevatorPos + Vector2(randi_range(50,90),randi_range(-90,90))

func grab(clawA):
	print("Bomb grabbed")
	explode()

func release(linVel):
	pass

func explode():
	var newExplosion = explosion.instantiate()
	newExplosion.global_position = global_position
	get_parent().add_child(newExplosion)
	
	var newEngine = engine.instantiate()
	newEngine.global_position = global_position
	get_parent().add_child(newEngine)
	
	queue_free()
	pass

func defuse():
	var newEngine = engine.instantiate()
	newEngine.global_position = global_position
	get_parent().add_child(newEngine)
	
	var newBarrel = engine.instantiate()
	newBarrel.global_position = global_position
	get_parent().add_child(newBarrel)
	
	queue_free()


func move(delta):
	angular_velocity = -rotation * 100 * delta
	var direction = global_position.direction_to(target).normalized()
	var speed = lerpf(linear_velocity.length(),maxSpeed,0.5)
	linear_velocity = direction * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	pass
