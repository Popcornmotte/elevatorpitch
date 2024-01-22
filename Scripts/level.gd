extends Node2D

const KATSCHING = preload("res://Assets/Audio/sfx/katsching.wav")
#const FORMATION_A = preload("res://Scenes/Objects/Enemies/Formations/formation_drones_a.tscn")
const D_RIFLE = preload("res://Scenes/Objects/Enemies/drone_rifle.tscn")
const D_SAW = preload("res://Scenes/Objects/Enemies/drone_saw.tscn")
const D_ROCKET = preload("res://Scenes/Objects/Enemies/drone_rocket.tscn")
const D_BARREL = preload("res://Scenes/Objects/Enemies/low_bomb.tscn")
const FADEOUT=preload("res://Scenes/UI/fade_out.tscn")
const FAILTRUMPET=preload("res://Assets/Audio/sfx/failTrumpet.wav")
var spawnChance = 20
var combat = false
var wave = 1
var elevatorDropping=false
@onready var finishedLevel=false
@onready var ENEMIES = [D_BARREL,D_RIFLE,D_SAW,D_ROCKET]
@onready var LevelFinish=get_node("LevelFinish")
@onready var gameOverText=get_node("GameOver")
var maxRocketeersAtOnce = 1
var finishHeight=50
var cargoCount = 0
var gainedFunds = 0
var lastHeight = 0
var gameOver=false
var tutorialLevel:bool=true
var tutorialWaveCounter=0
var failTrumpetSfx#used to stop trumpet if switching to main scene before the end of the sound

func _enter_tree():
	Global.level = self
# Called when the node enters the scene tree for the first time.
func _ready():
	maxRocketeersAtOnce = Global.currentContract.risk + 1
	Global.elevator.get_node("interior/Dispenser").locked=false
	gameOverText.hide()
	Global.elevator.fuel = max(Global.elevator.fuel,Global.fuelBetweenLevels)
	Global.elevator.moving=true
	Global.optionsMenu.switch(Global.TUTORIAL_INDICES.NET)

func setFinishHeight():
	var destination = Global.currentContract.destination
	finishHeight = 50 + 25*destination

func setGameOver(state:bool):
	if state:
		Global.gameOver()
	gameOver=state
	
func finishedScene():
	if !finishedLevel:#only play once
		$Elevator.onGoal()#plays the animation for elevator moving out of view
		$LevelCam.set_enabled(true)# enables level cam, so that elevator actually moves out of frame
		$LevelCam.make_current()
		finishedLevel=true
	
func spawn(number,types):
	var enemies = types
	var sign
	var rocketeers = 0
	for i in range(number):
			var e =  enemies[randi()%enemies.size()]
			if e == D_ROCKET:
				rocketeers+=1
				if rocketeers >= maxRocketeersAtOnce:
					enemies.pop_back()
			var enemy = e.instantiate()
			if(randi()%2 == 0):
				sign = 1
			else:
				sign =-1
			enemy.global_position =  Global.elevator.global_position + sign*Vector2(1500-64*i,randi_range(-800,800))
			add_child(enemy)
			
func spawnEnemies(tutorialLevel=false):
	combat = true
	if tutorialLevel:
		match tutorialWaveCounter:
			0:
				Global.optionsMenu.switch(Global.TUTORIAL_INDICES.FLING)
				spawn(3,[D_SAW])
			1:
				Global.optionsMenu.switch(Global.TUTORIAL_INDICES.SCRAPPING)
				spawn(4,[D_SAW,D_RIFLE])
			2:
				Global.optionsMenu.switch(Global.TUTORIAL_INDICES.SCRAPPING)
				spawn(5,[D_SAW,D_BARREL,D_RIFLE])
			3:
				Global.optionsMenu.switch(Global.TUTORIAL_INDICES.SCRAPPING)
				spawn(6,[D_SAW,D_BARREL,D_RIFLE,D_ROCKET])
		tutorialWaveCounter+=1
	else:
		var rocketeers = 0
		var enemies = ENEMIES
		spawnChance = -1
		wave += 1
		#var formation = FORMATION_A.instantiate()
		Global.elevator.brake.lock(true)
		lastHeight = Global.height
		var sign
		spawn(randi()%6 + wave + Global.currentContract.risk * 3, ENEMIES)
		#for i in range(randi()%6 + wave + Global.currentContract.risk * 3):
		#	var e =  enemies[randi()%enemies.size()]
		#	if e == D_ROCKET:
		#		rocketeers+=1
		#		if rocketeers >= maxRocketeersAtOnce:
		#			enemies.pop_back()
		#	var enemy = e.instantiate()
		#	if(randi()%2 == 0):
		#		sign = 1
		#	else:
		#		sign =-1
		#	enemy.global_position =  Global.elevator.global_position + sign*Vector2(1500-64*i,randi_range(-800,800))
		#	add_child(enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(combat):

		if Global.aliveEnemies <= 0:
			combat = false
			Global.elevator.brake.turnOffLightOnly()
			Global.elevator.brake.unlock()
			$WaveTimer.start()
	#check height for finish
	if not finishedLevel and Global.height>finishHeight:
		finishedScene()
	pass

func spawnExplosions():
	print("BOOM")

func endLevel(): #the elevator calls this when the docking animation is finished
	if Global.currentContract.risk == 3:
		if Global.anarchyContractsIndex == 1:
			spawnExplosions()
		Global.anarchyContractsIndex += 1
	
	$Elevator.haltElevator()
	$LevelFinish.show()
	cargoCount = Global.countItem(Item.TYPE.Cargo)
	Global.fuelBetweenLevels = Global.elevator.fuel
	$LevelFinish/NinePatchRect/CargoLabel.text = " : "+str(cargoCount)
	pass

func _on_wave_timer_timeout():
	if not finishedLevel:# do not spawn new enemies when level is already finished
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
		gainedFunds += Global.currentContract.pay
		$LevelFinish/NinePatchRect/FundsLabel.text = "Funds : "+str(gainedFunds)
		$LevelFinish/NinePatchRect/FundsLabel/AnimationPlayer.play("FundsWiggle")
		if(cargoCount == 0):
			$LevelFinish/NinePatchRect/DeliverButton.text = "Descend!"
			$LevelFinish/NinePatchRect/CargoSprite.hide()
	else:
		Global.addFunds(gainedFunds)
		$Elevator.dropElevator()

func spawnFadeOut():#called from elevator when dropping
	var fadeOut=FADEOUT.instantiate()
	if gameOver:
		failTrumpetSfx=Audio.playSfx(FAILTRUMPET,true)
	add_child(fadeOut)


func _on_end_timer_timeout():
	if gameOver:
		gameOverText.visible=true
	else:
		Audio.stopMusic()
		get_tree().change_scene_to_file("res://Scenes/UI/base_ui.tscn")



func _on_button_pressed():
	Audio.stopMusic()
	get_tree().change_scene_to_file("res://Scenes/UI/base_ui.tscn")

