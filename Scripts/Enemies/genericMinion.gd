extends RigidBody2D

const POP = preload("res://Assets/Audio/sfx/pop.wav")

@export var rangedBehavior = false
@export var weapon : Weapon
@export var maxSpeed = 50
@export var balloon : Node2D
@export var balloonShape : Node2D

var popped = false
var grabbed = false
var clawArea : Node2D
var speed : float
var reload = 0.0
var target : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	chooseTarget()
	pass

func chooseTarget():
	if rangedBehavior:
		target = global_position.direction_to(Global.elevator.global_position).normalized()
		target = target * global_position.distance_to(target)/2
	else:
		target = Global.elevator.global_position + Vector2(randi_range(-90,90),randi_range(-90,90))
	var debugmarker = load("res://Scenes/UI/debug_marker.tscn")
	var dbm = debugmarker.instantiate()
	get_parent().add_child(dbm)
	dbm.global_position = target
#called by the claw when grabbed. Will effectivly destory this minion
#so it can be used as a throwable
func grab(clawA):
	gravity_scale = 0
	clawArea = clawA
	grabbed = true
	set_collision_layer_value(1,false)
	set_collision_mask_value(1,false)
	if !popped:
		Audio.playSfx(POP)
		popped = true
		balloon.queue_free()
		balloonShape.queue_free()

	pass
func release(linVel):
	grabbed = false
	linear_velocity = linVel
	set_collision_layer_value(1,false)
	set_collision_mask_value(1,false)
	gravity_scale = 1

func move(delta) -> bool:
	if(!popped && !weapon.checkMeleeHit()):
		angular_velocity = -rotation * 10 * delta
		var direction = global_position.direction_to(target).normalized()
		speed = lerpf(linear_velocity.length(),maxSpeed,0.5)
		linear_velocity = direction * speed
		return true
	if(grabbed):
		global_position = clawArea.global_position
		return false
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(reload>0):reload-=delta
	move(delta)
	if rangedBehavior:
		if global_position.distance_to(target) <= 10:
			if (reload<=0):
				weapon.fire(global_position.direction_to(target).normalized())
				reload = weapon.reloadTime
	else:
		if(weapon.checkMeleeHit()):
			if (reload<=0):
				Global.elevator.takeDamage(weapon.damage)
				reload = weapon.reloadTime
		
