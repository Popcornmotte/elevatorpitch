extends Node

const fade = preload("res://Scenes/UI/fade_out.tscn")

@export var crateSpawnArea : CollisionShape2D
@export var brake : Node2D
@export var button : AnimatedSprite2D
@export var doorAreas : Array[Area2D]
var cratePrefab = preload("res://Scenes/Objects/Items/crate.tscn")
var hatchSound = preload("res://Assets/Audio/sfx/HangarVaultDoorNew.wav")
var hatchOpen = false
var elevatorRising = false
var spawnedCrates : Array[RigidBody2D]
var buttonDeployed = false
var redLight = false
var redLightFac = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Audio.playMusic("hangar")
	var spawnAreaRect = crateSpawnArea.shape.get_rect()
	var takenItem = Global.takeFromInventory(Item.TYPE.Cargo)
	while takenItem != null:
		var newCrate = cratePrefab.instantiate()
		add_child(newCrate)
		spawnedCrates.push_back(newCrate)
		var spawnPos = Vector2(0,0)
		spawnPos.x = randf_range(spawnAreaRect.position.x, spawnAreaRect.position.x + spawnAreaRect.size.x)
		spawnPos.y = randf_range(spawnAreaRect.position.y, spawnAreaRect.position.y + spawnAreaRect.size.y)
		newCrate.global_position = spawnPos + crateSpawnArea.global_position
		takenItem = Global.takeFromInventory(Item.TYPE.Cargo)
	
	pass # Replace with function body.

func onHatchButtonHit():
	if !hatchOpen:
		Audio.playSfx(hatchSound)
		$Background/OpenHatch.play("open")
		$ButtonArmAnim.play("retractButton")
		$Background/LightBlink.start()
		button.play("default")
		hatchOpen = true
		brake.startLocked = false
		brake.unlock()
		
		for area in doorAreas:
			area.call_deferred("queue_free")
	
func onElevatorStarted():
	$RiseSequence/ElevatorRise.play("elevatorRise")
	$RiseSequence/TransitionTimer.start()
	$RiseSequence/FadeTimer.start()
	elevatorRising = true
	Global.tutorialsCompleted[0] = true

func _on_area_2d_body_entered(body):
	onHatchButtonHit()

func _on_transitionTimer_timeout():
	Audio.stopMusic()
	get_tree().change_scene_to_file("res://Scenes/World/transition_scene.tscn")
	
func _on_fadeTimer_timeout():
	var fadeout = fade.instantiate()
	add_child(fadeout)

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
	
	if redLight:
		redLightFac = min(1, redLightFac + 16*delta)
	else:
		redLightFac = max(0, redLightFac - 16*delta)
	$Background/ParallaxBG/Lit.set_modulate(Color(1,1,1,redLightFac))


func _on_light_blink_timeout():
	redLight = !redLight
