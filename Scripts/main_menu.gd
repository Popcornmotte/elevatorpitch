extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Audio.playMusic("mainMenu")
	
	for element in Global.tutorialsCompleted:
		if element:
			$SaveGame/ResetTutorial.disabled = false
			break
	
	if !Global.newUser:
		$CenterContainer/Menu/StartButton.text = "[ Continue ]"
		$SaveGame/currentSave.text = " Current Save:  "+Global.username
		$SaveGame/DeleteSaveButton.disabled = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
	$CenterContainer/Menu/StartButton.text = "[ Start ]"
	$SaveGame/currentSave.text = " Current Save: None "
	$SaveGame/DeleteSaveButton.disabled = true
	pass # Replace with function body.


func _on_reset_tutorial_pressed():
	Global.tutorialsCompleted = [false, false, false, false]
	$SaveGame/ResetTutorial.disabled = true
	pass # Replace with function body.
