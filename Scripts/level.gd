extends Node2D

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
	
func spawnEnemies():
	combat = true
	spawnChance = 10
	wave += 1
	#var formation = FORMATION_A.instantiate()
	Global.elevator.brake.use_brake(true, true)
	var sign
	if(randi()%2 == 0):
		sign = 1
	else:
		sign =-1
	for i in range(randi()%6 + wave):
		var enemy = enemies[randi()%enemies.size()].instantiate()
		#enemy.DebugMode = true
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
	if not elevatorDropping:
		if not finishedLevel and Global.height>finishHeight:
			finishedScene()
		if finishedLevel and $Elevator.finishedFinalAnimation:
				$Elevator.haltElevator()
				$LevelFinish.visible=true
	else:
		if not $Elevator.onScreen:#the elevator is dropping and has left the screen, load loadScene
			get_tree().change_scene_to_file("res://Scenes/UI/base_ui.tscn")
	pass


func _on_wave_timer_timeout():
	print(finishedLevel)
	if not finishedLevel:# do not spawn new enemies when level is already finished
		print("spawn enemies")
		if(randi()%100 <= spawnChance):
			spawnEnemies()
		else:
			spawnChance += 10
			$WaveTimer.start()
		pass # Replace with function body.


func _on_deliver_button_pressed():
	var deliveredCargo=0
	while(Global.takeFromInventory(Item.TYPE.Cargo)!=null):
		deliveredCargo+=1
		
	Global.addFunds(deliveredCargo)
	$LevelFinish.get_node("CargoLabel").text= "Delivered Cargo: " +str(deliveredCargo)
	$LevelFinish.get_node("CargoLabel").visible=true
	$LevelFinish.get_node("EndTimer").start()#start timer, once complete, drop elevator
	


func _on_end_timer_timeout():
	elevatorDropping=true #so that ui does not get reenabled
	$LevelFinish.visible=false #disable the ui
	$Elevator.dropElevator()
