extends Node2D
class_name Elevator

const chutesDownSFX = preload("res://Assets/Audio/sfx/chuteDrop.wav")
const chutesUpSFX = preload("res://Assets/Audio/sfx/chuteRetract.wav")

var dropping = false
var speed = 0.0
var leakingFuel=false
var numberOperationalModules=5
var minOperationalModules=2
var maximumOperationalModules=5
var sfxWarning
#modules which can be broken by incoming damage
@onready var breakableModules=[$interior/Brake, $Net, $HullBody/Engine]
@export var statusLamps:Array[Node2D]=[]

@export var fuelBar : Node2D
@export var fuelAlert : Node2D
@export var heightMeter : Label
@export var controlArms:bool #make it accessible whether or not the arms are being controlled
@export var moving:bool=true
@export var chutesDeployed = false
@export var fuelConsumption=10
@export var fuel = 25.0
var maxFuel = 100.0
var heat=0
@export var maxHeat=100
@export var climbingHeight=0
@export var climbingRate=100
@export var speedModifier=1
@onready var targets = $Arms/Targets
@onready var brake=$interior/Brake
@onready var engine = $HullBody/Engine
@onready var operationalDisplay= $interior/DisplayText/Operational/MarginContainer/RichTextLabelDisplay
@onready var warningDisplay= $interior/DisplayText/MarginContainerWarning/RichTextLabelWarning
@onready var endTimer=$EndTimer
var warningBrokenModules=false
const REPAIRWARNING = preload("res://Assets/Audio/sfx/repairTimer.wav")
var explosion = preload("res://Scenes/Objects/explosion.tscn")
var explosionAmount=5
var explosionsTakenPlace=0

func _enter_tree():
	Global.elevator = self

func spawnExplosion():
	var newExplosion = explosion.instantiate()
	newExplosion.global_position = global_position+Vector2(randf_range(-100,100),randf_range(-100,100))
	get_parent().call_deferred("add_child",newExplosion)
				
				
func dropElevator(gameOver=false):#drops the elvator for example on finished game
	if(get_parent().get_node("LevelCam")):#otherwise we are still in the hangar
		dropping=true
		Global.player.hide()
		get_parent().get_node("LevelCam").set_enabled(true)# enables level cam, so that elevator actually moves out of frame
		get_parent().get_node("LevelCam").make_current()
		get_parent().setGameOver(gameOver)
		get_parent().get_node("LevelFinish").get_node("EndTimer").start()#start timer and drop elevator
		$HullBody.get_node("Hull").visible=true#make interior invisible when dropping
		get_parent().spawnFadeOut()
		if gameOver:
			$ExplosionTimer.start()
# Called when the node enters the scene tree for the first time.
func _ready():
	control(controlArms)
	updateFuel()#show correct fuel on game start
	updateDisplay()
	warningDisplay.hide()
	pass # Replace with function body.

func updateDisplay():
	if numberOperationalModules>4:
		operationalDisplay.clear()
		operationalDisplay.append_text("[color=green]%s[/color]"%["SYSTEMS OK: "+str(numberOperationalModules)+ "/5"])
	if numberOperationalModules==4||numberOperationalModules==3:
		operationalDisplay.clear()
		operationalDisplay.append_text("[color=orange]%s[/color]"%["SYSTEMS OK: "+str(numberOperationalModules)+ "/5"])
	if numberOperationalModules<=minOperationalModules:
		operationalDisplay.clear()
		operationalDisplay.append_text("[color=red]%s[/color]"%["SYSTEMS OK: "+str(numberOperationalModules)+ "/5"])
		
func brokenModulesWarning():
	warningDisplay.text="FAILURE IN "+ str(roundi(endTimer.get_time_left()))+"\nREPAIR NOW"
	if not dropping:
		if(!sfxWarning):
			sfxWarning=Audio.playSfx(REPAIRWARNING,true)
		if(!sfxWarning.playing):
			sfxWarning=Audio.playSfx(REPAIRWARNING,true)
			
			
func newBrokenModule():
	if numberOperationalModules>0:
		numberOperationalModules-=1
		if numberOperationalModules%2==0:
			statusLamps[2+numberOperationalModules/2].toggle(false)
		else:
			statusLamps[2-(numberOperationalModules/2+1)].toggle(false)
			
		if numberOperationalModules==minOperationalModules:
			operationalDisplay.hide()
			warningDisplay.show()
			warningBrokenModules=true
			endTimer.start()
		updateDisplay()
	
func newFixedModule():
	if numberOperationalModules<maximumOperationalModules:
		if numberOperationalModules%2==0:
			statusLamps[2+numberOperationalModules/2].toggle(true)
		else:
			statusLamps[2-(numberOperationalModules/2+1)].toggle(true)
		#statusLamps[numberOperationalModules].toggle(true)
		numberOperationalModules+=1
		if numberOperationalModules==minOperationalModules+1:
			operationalDisplay.show()
			warningDisplay.hide()
			if sfxWarning:
				sfxWarning.stop()
			warningBrokenModules=false
			endTimer.stop()
			warningDisplay.clear()
		updateDisplay()
	
func moveFast():
	speedModifier=2.0
	$LegsAndCable/Legs.movementFactor=speedModifier
	fuelConsumption=20
	
func moveNormal():
	speedModifier=1.0
	$LegsAndCable/Legs.movementFactor=speedModifier
	fuelConsumption=10
	engine.startEngine()
	
func control(isControlled : bool):
	controlArms=isControlled
	$HullBody/Hull.visible = isControlled
	for child in targets.get_children():
		if child is CharacterBody2D:#check that it is an arm
			child.control(isControlled)

func takeDamage(damage:int,type):
	#type is currently ignored in elevator
	var moduleToDamage=breakableModules[randi()%breakableModules.size()]
	moduleToDamage.damage(damage)
	pass

func on_area_entered(area : Area2D):
	if(area.has_meta("isProjectile")):
		if(area.damage != null):
			takeDamage(area.damage,Global.DMG.Bludgeoning)
	pass

func onGoal():
	$EndAnimation.play("goal")
	$HullBody.get_node("Hull").visible=true#make hull visible on goal
	if brake.currentSpeed == brake.SPEED.Fast:
		brake.switchDown()
	Global.player.setMovementParent(self)

func haltElevator():
	control(false)
	$HullBody.get_node("Hull").visible=true
	moving=false#stops cable from moving
	fuelConsumption=10 #Not zero to make the flamethrower still consume fuel
	
func update_height(climbed):
	climbingHeight+=climbed*speedModifier
	heightMeter.text= str("Height: ", int(climbingHeight), " m")

func decrease_fuel(delta):
	if fuel<=0:
		return
	fuel -= fuelConsumption*delta
	if fuel<=0:
		brake.noFuel()#set brake to turned off position
		moving=false
		engine.stopEngine()
		fuelAlert.visible = true
	else:
		update_height(climbingRate*speedModifier*delta)
	updateFuel()
	pass

func startLeaking():
	leakingFuel=true

func stopLeaking():
	leakingFuel=false
	
func updateFuel():
	fuelBar.scale = Vector2(fuel / 100.0, 1)
	if brake.locked and fuel > 0:
		brake.unlock()
	pass

func changeHeat(amount):
	if (amount<0 and heat>=0) or (amount>0 and heat<maxHeat):
		heat+=amount
		get_node("interior/HeatMeter").value=heat
		var factor = (heat-0.5*maxHeat)/(0.5*maxHeat)
		if heat<maxHeat*0.5:
			factor = 0
		get_node("interior/HeatMeter").set_tint_progress(Color(0.3,0.4,1.0).lerp(Color(1.0,0.3,0.1), factor))
		if heat>=maxHeat:
			get_node("HullBody/Engine").damage(maxHeat)#blow engine

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if warningBrokenModules:
		brokenModulesWarning()
	if leakingFuel:
		decrease_fuel(delta* 0.1)
	if(dropping):
		position -= Vector2(0,speed * delta)
		speed -= 400 * delta
	if moving:
		decrease_fuel(delta * 0.1)
	if(controlArms):
		if(!chutesDeployed and Input.is_action_just_pressed("down") and !$ChutesAnimation.is_playing()):
			chutesDeployed = true
			$ChutesAnimation.play("deployChutes")
			Audio.playSfx(chutesDownSFX)
			setChutesDeployed()
		elif(chutesDeployed and Input.is_action_just_pressed("up") and !$ChutesAnimation.is_playing()):
			chutesDeployed = false
			$ChutesAnimation.play("retractChutes")
			Audio.playSfx(chutesUpSFX)
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


func _on_end_timer_timeout():
	dropping=true
	sfxWarning.stop()
	dropElevator(true)#activate gameover scene


func _on_explosion_timer_1_timeout():
	explosionsTakenPlace+=1
	if explosionsTakenPlace<explosionAmount:
		$ExplosionTimer.start()
		spawnExplosion()


