extends Node2D
class_name Elevator

var maxHealth = 300.0
var health = maxHealth

var dropping = false
var speed = 0.0
#modules which can be broken by incoming damage
var breakableModules=[$interior/Brake, $Arms/PhysicalArmLeft, $Arms/PhysicalArmRight, $Net ]

@export var healthBar : Node2D
@export var fuelBar : Node2D
@export var fuelAlert : Node2D
@export var heightMeter : Label
@export var controlArms:bool #make it accessible whether or not the arms are being controlled
@export var moving:bool=true
@export var chutesDeployed = false
@export var fuelConsumption=10
@export var fuel = 5.0
@export var climbingHeight=0
@export var climbingRate=100
@export var speedModifier=1
@onready var targets = $Arms/Targets
@onready var brake=$interior/Brake
@onready var engineSFX = $HullBody/EngineSound
func _enter_tree():
	Global.elevator = self

func dropElevator():#drops the elvator for example on finished game
	if(get_parent().get_node("LevelCam")):#otherwise we are still in the hangar
		dropping=true
		get_parent().get_node("LevelCam").set_enabled(true)# enables level cam, so that elevator actually moves out of frame
		get_parent().get_node("LevelCam").make_current()
		get_parent().get_node("LevelFinish").get_node("EndTimer").start()#start timer and drop elevator
		$HullBody.get_node("Hull").visible=true#make interior invisible when dropping
# Called when the node enters the scene tree for the first time.
func _ready():
	control(controlArms)
	updateFuel()#show correct fuel on game start
	pass # Replace with function body.

func moveFast():
	speedModifier=2.0
	$LegsAndCable/Legs.movementFactor=speedModifier
	fuelConsumption=20
	
func moveNormal():
	speedModifier=1.0
	$LegsAndCable/Legs.movementFactor=speedModifier
	fuelConsumption=10
	engineSFX.startEngine()
	
func control(isControlled : bool):
	controlArms=isControlled
	$HullBody/Hull.visible = isControlled
	for child in targets.get_children():
		if child is CharacterBody2D:#check that it is an arm
			child.control(isControlled)

func takeDamage(damage:int,type):
	#type is currently ignored in elevator
	health -= damage
	var moduleToDamage=breakableModules[randi()%breakableModules.size()]
	moduleToDamage.damage(damage)
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
	$EndAnimation.play("goal")
	$HullBody.get_node("Hull").visible=true#make hull visible on goal

func haltElevator():
	control(false)
	$HullBody.get_node("Hull").visible=true
	moving=false#stops cable from moving
	
func update_height(climbed):
	climbingHeight+=climbed*speedModifier
	heightMeter.text= str("Height: ", int(climbingHeight), " m")

func decrease_fuel(delta):
	fuel -= fuelConsumption*delta
	if fuel<=0:
		brake.noFuel()#(brake.SPEED.Off,false,false)#set brake to turned off position
		engineSFX.stopEngine()
		fuelAlert.visible = true
	else:
		update_height(climbingRate*speedModifier*delta)
	updateFuel()
	pass

func updateFuel():
	fuelBar.scale = Vector2(fuel / 100.0, 1)
	if brake.locked and fuel > 0:
		brake.unlock()
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
	
	if(controlArms):
		if(!chutesDeployed and Input.is_action_just_pressed("down") and !$ChutesAnimation.is_playing()):
			chutesDeployed = true
			$ChutesAnimation.play("deployChutes")
			setChutesDeployed()
		elif(chutesDeployed and Input.is_action_just_pressed("up") and !$ChutesAnimation.is_playing()):
			chutesDeployed = false
			$ChutesAnimation.play("retractChutes")
			setChutesDeployed()

	pass
	
func setChutesDeployed():
	for child in $ItemChutes.get_children():
		if child is Area2D:
			child.get_child(0).disabled = !chutesDeployed
	$Arms/PhysicalArmLeft.setElbowDir(!chutesDeployed)
	$Arms/PhysicalArmRight.setElbowDir(!chutesDeployed)

func _on_animation_player_elevator_animation_finished(anim_name):
	Global.level.endLevel()

func startFuelTutorial():
	if $Tutorial/FuelPlace:
		$Tutorial/FuelPlace.open()
