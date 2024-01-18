extends Control

@onready var masterLabel = $Options/OptionsContainer/VBoxContainer/MasterVolumeLabel
@onready var masterSlider = $Options/OptionsContainer/VBoxContainer/MarginContainer/MasterVolumeSlider
@onready var musicLabel = $Options/OptionsContainer/VBoxContainer/MusicVolumeLabel
@onready var musicSlider = $Options/OptionsContainer/VBoxContainer/MarginContainer2/MusicVolumeSlider
@onready var effectsLabel = $Options/OptionsContainer/VBoxContainer/EffectsVolumeLabel
@onready var effectsSlider = $Options/OptionsContainer/VBoxContainer/MarginContainer3/EffectsVolumeSlider

@export var MainMenuVersion = false
# Called when the node enters the scene tree for the first time.
func _ready():
	masterSlider.value = Global.masterVolume
	masterLabel.text = "Master Volume: "+str(int(Global.masterVolume*100))
	musicSlider.value = Global.musicVolume
	musicLabel.text = "Music Volume: "+str(int(Global.musicVolume*100))
	effectsSlider.value = Global.effectsVolume
	effectsLabel.text = "Effects Volume: "+str(int(Global.effectsVolume*100))
	Global.optionsMenu = self
	
	if !MainMenuVersion:
		$CRT_shader.show()
		$pauseSprite.show()
	else:
		$CRT_shader.hide()
		$pauseSprite.hide()
		$Options/OptionsContainer/VBoxContainer/ButtonBox/QuitButton.text = "Back"
	
	pass # Replace with function body.

func switch( tutorial = -1 ):
	if visible:
		$WhiteNoisePlayer.stop()
		hide()
		get_tree().paused = false
		Global.saveGame()
	else:
		Global.saveGame()
		if !MainMenuVersion:
			$WhiteNoisePlayer.play()
		
		if tutorial >= 0 and !Global.animatedTutorialsCompleted[tutorial]:
			$Tutorials.show()
			$Tutorials.loadTutorial(tutorial)
			$Options/OptionsContainer.hide()
			Global.animatedTutorialsCompleted[tutorial]=true
		else:
			$Tutorials.hide()
			$Options/OptionsContainer.show()
		show()
		get_tree().paused = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Esc"):
		switch()
	pass


func _on_volume_slider_value_changed(value):
	Global.masterVolume = value #100 turned out to be a little loud...
	masterLabel.text = "Master Volume: "+str(int(value*100))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(Global.masterVolume))
	pass # Replace with function body.


func _on_quit_button_pressed():
	if MainMenuVersion:
		switch()
	else:
		Global.exitGame()
	pass # Replace with function body.


func _on_music_volume_slider_value_changed(value):
	Global.musicVolume = value #100 turned out to be a little loud...
	musicLabel.text = "Music Volume: "+str(int(value*100))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(Global.musicVolume))
	pass # Replace with function body.


func _on_effects_volume_slider_value_changed(value):
	Global.effectsVolume = value #100 turned out to be a little loud...
	effectsLabel.text = "Effects Volume: "+str(int(value*100))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), linear_to_db(Global.effectsVolume))
	pass # Replace with function body.


func _on_close_tutorial_button_pressed():
	switch()
	pass # Replace with function body.
