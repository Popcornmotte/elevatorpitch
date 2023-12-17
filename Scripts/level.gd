extends Node2D

const KATSCHING = preload("res://Assets/Audio/sfx/katsching.wav")
#const FORMATION_A = preload("res://Scenes/Objects/Enemies/Formations/formation_drones_a.tscn")
const D_RIFLE = preload("res://Scenes/Objects/Enemies/drone_rifle.tscn")
const D_SAW = preload("res://Scenes/Objects/Enemies/drone_saw.tscn")
const D_BARREL = preload("res://Scenes/Objects/Enemies/low_bomb.tscn")
var spawnChance = 20
var combat = false
var wave = 1
var elevatorDropping=false
@onready var finishedLevel=false
@onready var enemies = [D_BARREL,D_RIFLE,D_SAW]
@onready var LevelFinish=get_node("LevelFinish")
@export var finishHeight=50
var cargoCount = 0
var gainedFunds = 0
var lastHeight = 0

func _enter_tree():
	Global.level = self
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func finishedScene():
	$Elevator.onGoal()#plays the animation for elevator moving out of view
	$LevelCam.set_enabled(true)# enables level cam, so that elevator actually moves out of frame
	$LevelCam.make_current()
	finishedLevel=true
	Global.height = 0
	
func spawnEnemies():
	combat = true
	spawnChance = -1
	wave += 1
	#var formation = FORMATION_A.instantiate()
	Global.elevator.brake.useBrake(true, true)
	lastHeight = Global.height
	var sign
	for i in range(randi()%6 + wave):
		var enemy = enemies[randi()%enemies.size()].instantiate()
		if(randi()%2 == 0):
			sign = 1
		else:
			sign =-1
		enemy.global_position =  Global.elevator.global_position + sign*Vector2(1500-64*i,randi_range(-800,800))
		add_child(enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(combat):
		if Global.aliveEnemies <= 0:
			combat = false
			Global.elevator.brake.turnOffLightOnly()
			print("wave concluded")
			$WaveTimer.start()
	#check height for finish
	if not finishedLevel and Global.height>finishHeight:
		finishedScene()
	pass

func endLevel(): #the elevator calls this when the docking animation is finished
	$Elevator.haltElevator()
	$LevelFinish.show()
	cargoCount = Global.countItem(Item.TYPE.Cargo)
	$LevelFinish/NinePatchRect/CargoLabel.text = " : "+str(cargoCount)
	pass

func _on_wave_timer_timeout():
	if not finishedLevel:# do not spawn new enemies when level is already finished
		print("spawn")
		if(randi()%100 <= spawnChance):
			spawnEnemies()
		else:
			spawnChance += int((Global.height - lastHeight)) * 2
			$WaveTimer.start()
		pass # Replace with function body.


func _on_deliver_button_pressed():
	if (Global.takeFromInventory(Item.TYPE.Cargo)):
		cargoCount -= 1
		$LevelFinish/NinePatchRect/CargoLabel.text = " : "+str(cargoCount)
		FX.playFX("crateVanish",$LevelFinish/NinePatchRect/CargoSprite.global_position+Vector2(0,-64))
		Audio.playSfx(KATSCHING)
		gainedFunds += 10
		$LevelFinish/NinePatchRect/FundsLabel.text = "Funds : "+str(gainedFunds)
		$LevelFinish/NinePatchRect/FundsLabel/AnimationPlayer.play("FundsWiggle")
		if(cargoCount == 0):
			$LevelFinish/NinePatchRect/DeliverButton.text = "Descend!"
			$LevelFinish/NinePatchRect/CargoSprite.hide()
	else:
		Global.addFunds(gainedFunds)
		$LevelFinish.get_node("EndTimer").start()#start timer and drop elevator
		$Elevator.dropElevator()



func _on_end_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/UI/base_ui.tscn")

