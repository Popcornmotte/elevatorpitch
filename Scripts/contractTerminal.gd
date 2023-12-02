extends Control

const FLASHBULB = preload("res://Assets/Audio/sfx/flashbulb.wav")

var flashMode = true
@onready var flashLabel = $Monitor/Terminal/FlashLabel 
var index = -1
var flashText = ["SELECT A CONTRACT", "LOAD UP YOUR CARGO SPACE", "CLIMB UP!", "DEFEND!", "DELIVER!", "FALL BACK DOWN!"]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func flashNext():
	index += 1
	if index >= flashText.size():
		flashMode = false
		flashLabel.hide()
		$Monitor/Terminal/Contracts.show()
		Audio.playSfx(FLASHBULB)
	else:
		flashLabel.text = flashText[index]
		Audio.playSfx(FLASHBULB)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flashMode:
		if Input.is_action_just_pressed("Grab"):
			flashNext()
	pass
