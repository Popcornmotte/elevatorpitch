extends RigidBody2D

class_name Enemy

const isEnemyEntity = true
#damage types in order: bludgeoning, piercing, force, fire, lighting
@export var damageFactors = [1,1,1,1,1]
@export var hitPoints = 100.0
@onready var maxHitPoints = hitPoints
@export var rangedBehavior = false
@export var effectiveRange = 400
@export var effectiveRangeVariance = 50
@export var attacksStealCargo = false
@export var stealChancePercent = 25
@export var weapon : Weapon
@export var maxSpeed = 50
@export var despawnOnScreenExitTimer = 30.0
@export var attacksPerTurn = 2
#if debug mode enabled, draw target positions
@export var DebugMode = false

enum STATE {Attacking, Repositioning, Fleeing}
var state = STATE.Attacking

var dead = false
var grabbed = false
var attackTimer = 0
var attackTime = 1
var timerJustEnded = true
var clawArea : Node2D #reference needed for grabbing and force integration
var speed : float
var reload = 0.0
var target : Vector2
#Factor to compensate target finding for from which side enemy attacks from
var approachDir = 1
var elevatorPos : Vector2

#possible stolen loot to take away
var loot
#debug marker
var dbm
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.aliveEnemies += 1
	elevatorPos = Global.elevator.global_position
	if weapon != null:
		attackTime = weapon.reloadTime * attacksPerTurn
	attackTimer = attackTime

	if(!has_method("_on_body_entered")):
		printerr(str(name)+"This Enemy does not have a _on_body_entered signal to determine collision damage!")
	
	call_deferred("chooseTarget")
	pass # Replace with function body.

func _integrate_forces(state):
	if(grabbed):
		global_position = clawArea.global_position

func flip(dir):
	if !dead:
		if weapon != null:
			weapon.flipH(dir)

#called by the claw when grabbed. Will effectivly destory this minion
#so it can be used as a throwable
func grab(clawA):
	gravity_scale = 0
	clawArea = clawA
	grabbed = true
	set_collision_layer_value(1,false)
	set_collision_mask_value(1,false)
	#remove Layer 3 collision as fix to not get stuck on arm with violent throws
	set_collision_layer_value(3,false)
	set_collision_mask_value(3,false)
	
	takeDamage(110,Global.DMG.Bludgeoning)

func release(linVel):
	grabbed = false
	linear_velocity = linVel
	set_collision_layer_value(1,true)
	set_collision_mask_value(1,true)
	gravity_scale = 1

func die():
	dead = true
	Global.aliveEnemies -= 1
	gravity_scale = 1

func takeDamage(damage : int, type):
	var factor = damageFactors[type]
	hitPoints -= damage * factor
	if(!dead && hitPoints <=0 ):
		die()

func chooseTarget():
	if dead:
		return
	if(DebugMode && dbm != null):
		dbm.queue_free()
	if(global_position.x < Global.elevator.global_position.x):
		#Left of elevator
		approachDir = -1
	else:
		#Right of elevator
		approachDir = 1
	#ranged enemies should (for now) find a spot roughly in grabbing range and
	#start shooting from there
	if rangedBehavior:
		target = global_position.direction_to(elevatorPos).normalized()
		target = elevatorPos - target * (effectiveRange+randi_range(-effectiveRangeVariance,effectiveRangeVariance))
	#Melee enemies should target a random part on the elevator and move towards that
	else:
		match state:
			STATE.Attacking:
				target = elevatorPos + approachDir*Vector2(randi_range(50,90),randi_range(-90,90))
			STATE.Repositioning:
				target = elevatorPos + approachDir*Vector2(randi_range(200,340),randi_range(-200,200))
			STATE.Fleeing:
				target = elevatorPos + approachDir*Vector2(2000, randi_range(-500,500))
	
	if (target.x > global_position.x ):
		flip(1)
	else:
		flip(0)

func attackBehavior(delta):
	if attackTimer >= 0:
		attackTimer -= delta
	elif timerJustEnded:
		timerJustEnded = false
		if state != STATE.Fleeing:
			state = STATE.Repositioning
		chooseTarget()
	
	if rangedBehavior:
		if global_position.distance_to(target) <= 10:
			if (reload<=0):
				weapon.fire(global_position.direction_to(elevatorPos).normalized())
				reload = weapon.reloadTime
	else:
		if(weapon.checkMeleeHit() && state == STATE.Attacking):
			if attackTimer <= 0:
				timerJustEnded = true
				attackTimer = attackTime
			if (reload<=0):
				Global.elevator.takeDamage(weapon.damage, Global.DMG.Piercing)
				Audio.playSfx(weapon.weaponSound)
				if(attacksStealCargo):
					if(randi()%100 <= stealChancePercent):
						stealCargo()
				reload = weapon.reloadTime

func stealCargo():
	if(Global.checkForCargo()):
		var lootPath = Global.takeFromInventory(Item.TYPE.Cargo).getObjectInstance()
		$Crate.visible = true
		$Crate.mass = 5
		state = STATE.Fleeing
		chooseTarget()
		Global.aliveEnemies -= 1
		return

func move(delta) -> bool:
	if(grabbed):
		return false
	if(!dead):
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
	return false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#simplified despawn:
	if(global_position.distance_to(elevatorPos) > 3000):
		if(dbm != null):
			dbm.queue_free()
		queue_free()
	if weapon != null:
		attackBehavior(delta)
	move(delta)
	if(DebugMode && dbm == null):
		var debugmarker = load("res://Scenes/UI/debug_marker.tscn")
		dbm = debugmarker.instantiate()
		get_parent().add_child(dbm)
		dbm.global_position = target
	if(reload>0):reload-=delta
	pass
