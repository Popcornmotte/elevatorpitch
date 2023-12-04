extends Node2D

const VAULTOPEN = preload("res://Assets/Audio/sfx/vaultOpen.wav")

func _ready():
	$animation.play("default")
	Audio.playSfx(VAULTOPEN)

func _on_animation_animation_finished():
	get_tree().change_scene_to_file("res://Scenes/World/test_scenes.tscn")
	pass # Replace with function body.
