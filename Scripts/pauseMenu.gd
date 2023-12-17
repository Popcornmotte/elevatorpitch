extends Control

@onready var volumeLabel = $Polygon2D/MarginContainer/VBoxContainer/VolumeBox/Label
# Called when the node enters the scene tree for the first time.
func _ready():
	$Polygon2D/MarginContainer/VBoxContainer/MarginContainer/VolumeSlider.value = Global.masterVolume
	volumeLabel.text = "Master Volume: "+str(int(Global.masterVolume*100))
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
	volumeLabel.text = "Master Volume: "+str(int(value*100))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(Global.masterVolume))
	pass # Replace with function body.


func _on_quit_button_pressed():
	Global.exitGame()
	pass # Replace with function body.
