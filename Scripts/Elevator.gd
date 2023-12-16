extends Node2D
class_name Elevator

var maxHealth = 300.0
var health = maxHealth

var dropping = false
var speed = 0.0

@export var healthBar : Node2D
@export var fuelBar : Node2D
@export var fuelAlert : Node2D
@export var heightMeter : Label
@export var controlArms:bool #make it accessible whether or not the arms are being controlled
@export var moving:bool=true
@export var fuelConsumption=10
@export var fuel = 25.0
@export var climbingHeight=0
@export var climbingRate=100
@onready var targets = $Arms/Targets
@onready var brake=$interior/Brake
@onready var engineSFX = $HullBody/EngineSound

func _enter_tree():
	Global.elevator = self

func dropElevator():#drops the elvator for example on finished game
	dropping=true
	$HullBody.get_node("Hull").visible=true#make interior invisible when dropping
# Called when the node enters the scene tree for the first time.
func _ready():
	control(controlArms)
	moving=true
	updateFuel()#show correct fuel on game start
	pass # Replace with function body.

func control(isControlled : bool):
	controlArms=isControlled
	$HullBody/Hull.visible = isControlled
	for child in targets.get_children():
		if child is CharacterBody2D:#check that it is an arm
			child.control(isControlled)

func takeDamage(damage:int):
	health -= damage
	update_health()
	pass

func on_area_entered(area : Area2D):
	if(area.has_meta("isProjectile")):
		if(area.damage != null):
			health -= area.damage
			update_health()
	pass

func update_health():
	if(!dropping):
		if(health <= 0):
			# Lose
			dropping = true
			speed = 150
			pass
		healthBar.scale = Vector2(health / maxHealth, 1)
	pass

func onGoal():
	$AnimationPlayerElevator.play("goal")
	$HullBody.get_node("Hull").visible=true#make hull visible on goal

func haltElevator():
	control(false)
	$HullBody.get_node("Hull").visible=true
	moving=false#stops cable from moving
	
func update_height(climbed):
	climbingHeight+=climbed
	heightMeter.text= str("Height: ", int(climbingHeight), " m")

func decrease_fuel(delta):
	fuel -= fuelConsumption*delta
	if fuel<=0:
		brake.useBrake(brake.SPEED.Off,false,false)#set brake to turned off position
		engineSFX.stopEngine()
		fuelAlert.visible = true
	else:
		update_height(climbingRate*delta)
	updateFuel()
	pass

func updateFuel():
	fuelBar.scale = Vector2(fuel / 100.0, 1)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
#	if(get_local_mouse_position().y < 0):
#		$Skeleton2D.get_modification_stack().get_modification(0).set_ccdik_joint_constraint_angle_invert(2,true)
#	else:
#		$Skeleton2D.get_modification_stack().get_modification(0).set_ccdik_joint_constraint_angle_invert(2,false)
	if(dropping):
		position -= Vector2(0,speed * delta)
		speed -= 400 * delta

	pass

func _on_animation_player_elevator_animation_finished(anim_name):
	Global.level.endLevel()
