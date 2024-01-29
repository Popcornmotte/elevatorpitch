extends Control

@onready var masterLabel = $Options/OptionsContainer/VBoxContainer/MasterVolumeLabel
@onready var masterSlider = $Options/OptionsContainer/VBoxContainer/MarginContainer/MasterVolumeSlider
@onready var musicLabel = $Options/OptionsContainer/VBoxContainer/MusicVolumeLabel
@onready var musicSlider = $Options/OptionsContainer/VBoxContainer/MarginContainer2/MusicVolumeSlider
@onready var effectsLabel = $Options/OptionsContainer/VBoxContainer/EffectsVolumeLabel
@onready var effectsSlider = $Options/OptionsContainer/VBoxContainer/MarginContainer3/EffectsVolumeSlider

@export var MainMenuVersion = false

var currentlyLookingAtTutorial=0
var showTutorials=[Global.TUTORIAL_INDICES.DISPENSER,Global.TUTORIAL_INDICES.REPAIR,Global.TUTORIAL_INDICES.FUELING,
Global.TUTORIAL_INDICES.ARMSTATION, Global.TUTORIAL_INDICES.CHUTES,Global.TUTORIAL_INDICES.HATCH, Global.TUTORIAL_INDICES.BRAKE, Global.TUTORIAL_INDICES.FLING, 
Global.TUTORIAL_INDICES.BOMBS,Global.TUTORIAL_INDICES.SCRAPPING,Global.TUTORIAL_INDICES.ROCKETS, Global.TUTORIAL_INDICES.ARMMODULE]
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

func switch( tutorial:float = -1, showTutorials:bool=false ):
	if visible:
		if showTutorials:
			$Tutorials.show()
			$Tutorials.loadTutorial(tutorial)
			$Options/OptionsContainer.hide()
			$Tutorials/Tutoriallist.show()
		else:
			$WhiteNoisePlayer.stop()
			hide()
			get_tree().paused = false
			Global.saveGame()
		
	else:
		if tutorial >= 0 :
			while Global.animatedTutorialsCompleted.size() <= tutorial:
				Global.animatedTutorialsCompleted.push_back(false)
			
			if !Global.animatedTutorialsCompleted[tutorial]:
				$Tutorials.show()
				$Tutorials.loadTutorial(tutorial)
				$Options/OptionsContainer.hide()
				$Tutorials/Tutoriallist.hide()
				Global.animatedTutorialsCompleted[tutorial]=true
			else:
				return
		else:
			$Tutorials.hide()
			$Options/OptionsContainer.show()
		if !MainMenuVersion:
			$WhiteNoisePlayer.play()
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


func _on_tutorial_button_pressed():
	switch(showTutorials[currentlyLookingAtTutorial],true)


func _on_tutoriallist_item_selected(index):
	switch(showTutorials[index],true)
	currentlyLookingAtTutorial=index
