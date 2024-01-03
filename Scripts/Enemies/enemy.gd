extends RigidBody2D

class_name Enemy

const isEnemyEntity = true
#damage types in order: bludgeoning, piercing, force, fire, lighting
@export var damageFactors = [1,1,1,1,1]
@export var hitPoints = 100.0
@onready var maxHitPoints = hitPoints
@export var rangedBehavior = false
@export var effectiveRange = 0
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
var popped = false
var grabbed = false
var clawArea : Node2D #reference needed for grabbing and force integration
var speed : float
var reload = 0.0
var target : Vector2
#Factor to compensate target finding for from which side enemy attacks from
var approachDir = 1
var elevatorPos : Vector2

#debug marker
var dbm
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.aliveEnemies += 1
	elevatorPos = Global.elevator.global_position
	call_deferred("chooseTarget")
	pass # Replace with function body.

func _integrate_forces(state):
	if(grabbed):
		global_position = clawArea.global_position

func flip(dir):
	print("Super Flip!")
	if !dead:
		weapon.flipH(dir)

func chooseTarget():
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
		target = elevatorPos - target * 400
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
