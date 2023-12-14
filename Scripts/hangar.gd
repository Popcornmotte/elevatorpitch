extends Node

@export var crateSpawnArea : CollisionShape2D
@export var brake : Node2D
@export var button : AnimatedSprite2D
var cratePrefab = preload("res://Scenes/Objects/Items/crate.tscn")
var hatchSound = preload("res://Assets/Audio/sfx/vaultOpen.wav")
var hatchOpen = false
var elevatorRising = false
var spawnedCrates : Array[RigidBody2D]
var buttonDeployed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var spawnAreaRect = crateSpawnArea.shape.get_rect()
	var i = 0
	while(i < Global.inventory.size()):
		if(Global.inventory[i].type != Item.TYPE.Cargo):
			i += 1
		else:
			Global.inventory.remove_at(i)
			var newCrate = cratePrefab.instantiate()
			add_child(newCrate)
			spawnedCrates.push_back(newCrate)
			var spawnPos = Vector2(0,0)
			spawnPos.x = randf_range(spawnAreaRect.position.x, spawnAreaRect.position.x + spawnAreaRect.size.x)
			spawnPos.y = randf_range(spawnAreaRect.position.y, spawnAreaRect.position.y + spawnAreaRect.size.y)
			newCrate.global_position = spawnPos + crateSpawnArea.global_position
	
	pass # Replace with function body.

func onHatchButtonHit():
	if !hatchOpen:
		Audio.playSfx(hatchSound)
		button.play("default")
		hatchOpen = true
		brake.unlocked = true
	
func onElevatorStarted():
	$RiseSequence/ElevatorRise.play("elevatorRise")
	$RiseSequence/Timer.start()
	elevatorRising = true

func _on_area_2d_body_entered(body):
	onHatchButtonHit()

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/World/transition_scene.tscn")

func _process(delta):
	if !buttonDeployed:
		var remainingCrates = 0
		for crate in spawnedCrates:
			if crate != null:
				remainingCrates += 1
		if remainingCrates == 0:
			$ButtonArmAnim.play("deployButton")
			buttonDeployed = true
	if hatchOpen and !elevatorRising and Global.elevator.moving:
		onElevatorStarted()
