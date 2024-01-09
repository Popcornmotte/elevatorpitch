extends Node2D

@onready var lever=$Lever
var startingPos=Vector2(0,10)
var endPos=Vector2(0,-10)
@export var finishHeight=50#currently hardcoded
@onready var heightScale=finishHeight/20

func _process(delta):
	var leverPos=Vector2(0,round(Global.height/heightScale+10))
	lever.position=leverPos
