extends Node2D

@onready var onSprite=$On
@onready var offSprite=$Off
@onready var light=$Light

func _ready():
	toggle(true)
	
func toggle(state:bool):#true turns it on, false turns it off
	onSprite.visible=state
	light.visible=state
	offSprite.visible=!state
