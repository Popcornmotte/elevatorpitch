extends Node2D
class_name Elevator

var health = 100

var lost = false
var speed = 0.0

@export var healthBar : Node2D
@export var fuelBar : Node2D
@export var controlArms:bool #make it accessible whether or not the arms are being controlled
@export var moving:bool=true
@onready var targets = $Arms/Targets
@export var fuel = 100.0
@onready var brake=$interior/Brake

func _enter_tree():
	Global.elevator = self

# Called when the node enters the scene tree for the first time.
func _ready():
	$HullBody/AnimationPlayer.play("EngineJiggle")
	control(controlArms)
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
	if(!lost):
		if(health <= 0):
			# Lose
			lost = true
			speed = 150
			pass
		healthBar.scale = Vector2(health / 100.0, 1)
	pass

func decrease_fuel(delta):
	fuel -= delta
	if fuel<=0:
		moving=false#stop elevator when there is no fuel available
		brake._use_brake(false)#set brake to turned off position
	else:
		moving=true
	update_fuel()
	pass

func update_fuel():
	fuelBar.scale = Vector2(fuel / 100.0, 1)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
#	if(get_local_mouse_position().y < 0):
#		$Skeleton2D.get_modification_stack().get_modification(0).set_ccdik_joint_constraint_angle_invert(2,true)
#	else:
#		$Skeleton2D.get_modification_stack().get_modification(0).set_ccdik_joint_constraint_angle_invert(2,false)
	if(lost):
		position -= Vector2(0,speed * delta)
		speed -= 400 * delta
	pass


func _on_engine_sound_finished():
	$HullBody/EngineSound.play()
	pass # Replace with function body.
