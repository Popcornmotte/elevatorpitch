extends Node2D

const VAULTOPEN = preload("res://Assets/Audio/sfx/vaultOpen.wav")
const STATIONS = ["station1", "station2", "station3"]
@onready var animation : AnimatedSprite2D = $animation


func _ready():
	$animation.play("exitHangar")
	Audio.playSfx(VAULTOPEN)
	Global.height = 0

func _on_animation_animation_finished():
	if animation.animation == "exitHangar":
		animation.play(STATIONS[randi()%3])
	else:
		
		get_tree().change_scene_to_file("res://Scenes/World/test_scenes.tscn")
	pass # Replace with function body.
