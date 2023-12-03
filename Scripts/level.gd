extends Node2D

#const FORMATION_A = preload("res://Scenes/Objects/Enemies/Formations/formation_drones_a.tscn")
const D_RIFLE = preload("res://Scenes/Objects/Enemies/drone_rifle.tscn")
const D_SAW = preload("res://Scenes/Objects/Enemies/drone_saw.tscn")
const D_BARREL = preload("res://Scenes/Objects/Enemies/low_bomb.tscn")
var spawnChance = 100
var combat = false
var wave = 1
@onready var enemies = [D_BARREL,D_RIFLE,D_SAW]

func _enter_tree():
	Global.level = self
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
	pass


func _on_wave_timer_timeout():
	if(randi()%100 <= spawnChance):
		spawnEnemies()
	else:
		spawnChance += 10
		$WaveTimer.start()
	pass # Replace with function body.
