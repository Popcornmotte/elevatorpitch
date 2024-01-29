extends Node2D

const FLASH = preload("res://Assets/Audio/sfx/flashbulb.wav")

@onready var onSprite=$On
@onready var offSprite=$Off
@onready var light=$Light

func _ready():
	toggle(true)
	
func toggle(state:bool):#true turns it on, false turns it off
	if !state:
		Audio.playSfx(FLASH)
	#onSprite.visible=state
	light.visible=!state
	#offSprite.visible=!state
	$Sprite.play("off" if state else "on")
