extends Node2D

@onready var lever=$Lever
@export var finishHeight=50#currently hardcoded
@onready var heightScale:float=2.77777

func _process(delta):
	var leverPos=Vector2(0,round(7-Global.height/heightScale))
	lever.position=leverPos
