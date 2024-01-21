extends Control

@export var titleText: Array[String]=[]
@export var explanationText:Array[String]=[]
@onready var explanation=$Explanation
@onready var header=$Header

func loadTutorial(index):
	$Animations.play(str(index))
	explanation.text=explanationText[index]
	header.text=titleText[index]
