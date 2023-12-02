extends Node2D

#const FORMATION_A = preload("res://Scenes/Objects/Enemies/Formations/formation_drones_a.tscn")
const D_RIFLE = preload("res://Scenes/Objects/Enemies/drone_rifle.tscn")
const D_SAW = preload("res://Scenes/Objects/Enemies/drone_saw.tscn")
const D_BARREL = preload("res://Scenes/Objects/Enemies/low_bomb.tscn")
@onready var enemies = [D_BARREL,D_RIFLE,D_SAW]

func _enter_tree():
	Global.level = self
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawnEnemies():
	#var formation = FORMATION_A.instantiate()
	var sign
	if(randi()%2 == 0):
		sign = 1
	else:
		sign =-1
	for i in range(randi()%5 + 1):
		var enemy = enemies[randi()%enemies.size()].instantiate()
		#enemy.DebugMode = true
		enemy.global_position = sign * Vector2(2000-64*i,randi_range(-1000,1000))
		add_child(enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_wave_timer_timeout():
	spawnEnemies()
	$WaveTimer.start()
	pass # Replace with function body.
