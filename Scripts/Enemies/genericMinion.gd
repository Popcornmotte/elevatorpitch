extends RigidBody2D

const POP = preload("res://Assets/Audio/sfx/pop.wav")

@export var rangedBehavior = false
@export var weapon : Weapon
@export var maxSpeed = 50
@export var balloon : Node2D
@export var balloonShape : Node2D
@export var despawnOnScreenExitTimer = 30
#if debug mode enabled, draw target positions
@export var DebugMode = false

enum STATE {Attacking, Repositioning}
var state = STATE.Attacking

var popped = false
var grabbed = false
var clawArea : Node2D
var speed : float
var reload = 0.0
var target : Vector2



var elevatorPos : Vector2
#debug marker
var dbm

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = despawnOnScreenExitTimer
	elevatorPos = Global.elevator.global_position
	chooseTarget()
	pass

func chooseTarget():
	if(DebugMode && dbm != null):
		dbm.queue_free()
	#ranged enemies should (for now) find a spot roughly in grabbing range and
	#start shooting from there
	if rangedBehavior:
		target = global_position.direction_to(elevatorPos).normalized()
		target = global_position + target * global_position.distance_to(elevatorPos)/1.7
	#Melee enemies should target a random part on the elevator and move towards that
	else:
		match state:
			STATE.Attacking:
				target = elevatorPos + Vector2(randi_range(50,90),randi_range(-90,90))
			STATE.Repositioning:
				target = elevatorPos + Vector2(randi_range(200,340),randi_range(-200,200))

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
	set_collision_layer_value(1,true)
	set_collision_mask_value(1,true)
	gravity_scale = 1

func move(delta) -> bool:
	if(!popped):
		if rangedBehavior && global_position.distance_to(target) < 10:
			return false
		if(!weapon.checkMeleeHit() || state == STATE.Repositioning):
			angular_velocity = -rotation * 100 * delta
			var direction = global_position.direction_to(target).normalized()
			speed = lerpf(linear_velocity.length(),maxSpeed,0.5)
			linear_velocity = direction * speed
			if(state == STATE.Repositioning && global_position.distance_to(target) <= 10):
				state = STATE.Attacking
				chooseTarget()
			return true
	if(grabbed):
		global_position = clawArea.global_position
		return false
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(DebugMode && dbm == null):
		var debugmarker = load("res://Scenes/UI/debug_marker.tscn")
		dbm = debugmarker.instantiate()
		get_parent().add_child(dbm)
		dbm.global_position = target
	
	if(reload>0):reload-=delta
	
	move(delta)
	
	if rangedBehavior:
		if global_position.distance_to(target) <= 10:
			if (reload<=0):
				weapon.fire(global_position.direction_to(elevatorPos).normalized())
				reload = weapon.reloadTime
	else:
		if(weapon.checkMeleeHit()):
			if (reload<=0):
				Global.elevator.takeDamage(weapon.damage)
				reload = weapon.reloadTime
				state = STATE.Repositioning
				chooseTarget()
		



func _on_visible_on_screen_notifier_2d_screen_exited():
	if popped:
		$Timer.start()
	pass # Replace with function body.


func _on_timer_timeout():
	if(dbm != null):
		dbm.queue_free()
	queue_free()
	pass # Replace with function body.
