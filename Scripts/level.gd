extends Node2D

const FORMATION_A = preload("res://Scenes/Objects/Enemies/Formations/formation_drones_a.tscn")

func _enter_tree():
	Global.level = self
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawnEnemies():
	var formation = FORMATION_A.instantiate()
	var sign
	if(randi()%2 == 0):
		sign = 1
	else:
		sign =-1
	formation.position = sign * Vector2(2000,randi_range(-500,500))
	add_child(formation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_wave_timer_timeout():
	spawnEnemies()
	$WaveTimer.start()
	pass # Replace with function body.
