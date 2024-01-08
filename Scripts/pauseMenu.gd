extends Control

@onready var masterLabel = $Polygon2D/MarginContainer/VBoxContainer/MasterVolumeLabel
@onready var masterSlider = $Polygon2D/MarginContainer/VBoxContainer/MarginContainer/MasterVolumeSlider
@onready var musicLabel = $Polygon2D/MarginContainer/VBoxContainer/MusicVolumeLabel
@onready var musicSlider = $Polygon2D/MarginContainer/VBoxContainer/MarginContainer2/MusicVolumeSlider
@onready var effectsLabel = $Polygon2D/MarginContainer/VBoxContainer/EffectsVolumeLabel
@onready var effectsSlider = $Polygon2D/MarginContainer/VBoxContainer/MarginContainer3/EffectsVolumeSlider
# Called when the node enters the scene tree for the first time.
func _ready():
	masterSlider.value = Global.masterVolume
	masterLabel.text = "Master Volume: "+str(int(Global.masterVolume*100))
	musicSlider.value = Global.masterVolume
	musicLabel.text = "Music Volume: "+str(int(Global.musicVolume*100))
	effectsSlider.value = Global.masterVolume
	effectsLabel.text = "Effects Volume: "+str(int(Global.effectsVolume*100))
	Global.optionsMenu = self
	pass # Replace with function body.

func switch():
	if visible:
		$WhiteNoisePlayer.stop()

		hide()
		get_tree().paused = false
		Global.saveGame()
	else:
		Global.saveGame()

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
