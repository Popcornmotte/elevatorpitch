extends Control

const FLOODLIGHTS = preload("res://Assets/Audio/sfx/floodLights.wav")
const ELEVATORLIGHTS = preload("res://Assets/Audio/sfx/lightsFlickerOn.wav")
const REDFLICK = preload("res://Assets/Audio/sfx/redLightFlick.wav")

var clickToStart = false
var stage = 0

@export var GrainShader = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Background.play("dark")
	Audio.playMusic("mainMenu")
	
	if GrainShader:
		$GrainShader.show()
	else:
		$GrainShader.hide()
	
	for element in Global.tutorialsCompleted:
		if element:
			$SaveGame/ResetTutorial.disabled = false
			break
	
	if !Global.newUser:
		$MenuContainer/Menu/StartButton.text = "[ Continue ]"
		$SaveGame/currentSave.text = " Current Save:  "+Global.username
		$SaveGame/DeleteSaveButton.disabled = false
	pass # Replace with function body.


func _input(event):
	if clickToStart:
		if (event is InputEventKey and event.is_pressed()) or (event is InputEventMouseButton):
			$PressAnyKey.hide()
			Audio.playSfx(REDFLICK)
			clickToStart = false
			$Background.play("litWithBlink")
			$AnimationPlayer.play("FadeIn")

func _on_start_button_pressed():
	Audio.stopMusic()
	get_tree().change_scene_to_file("res://Scenes/UI/base_ui.tscn")
	pass # Replace with function body.


func _on_options_button_pressed():
	$PauseMenu/Pause.switch()
	pass # Replace with function body.


func _on_quit_button_pressed():
	Global.exitGame()
	pass # Replace with function body.


func _on_delete_save_button_pressed():
	Global.gameOver()
	$MenuContainer/Menu/StartButton.text = "[ Start ]"
	$SaveGame/currentSave.text = " Current Save: None "
	$SaveGame/DeleteSaveButton.disabled = true
	pass # Replace with function body.


func _on_reset_tutorial_pressed():
	Global.tutorialsCompleted = [false, false, false, false]
	$SaveGame/ResetTutorial.disabled = true
	pass # Replace with function body.


func _on_timer_timeout():
	match stage:
		0:
			$Background.play("elevatorLit")
			Audio.playSfx(ELEVATORLIGHTS)
			stage = 1
			$Timer.start()
		1:
			$Background.play("lit")
			Audio.playSfx(FLOODLIGHTS)
			stage = 2
			$Timer.start()
		2:
			$PressAnyKey.show()
			clickToStart = true
			pass

	pass # Replace with function body.


func _on_background_animation_looped():
	if $Background.animation == "litWithBlink":
		Audio.playSfx(REDFLICK)
	pass # Replace with function body.
