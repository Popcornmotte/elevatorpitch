extends AnimatedSprite2D

@export var titleText: Array[String]=[]
@export var explanationText:Array[String]=[]
@onready var explanation=$Explanation
@onready var header=$Header

func loadTutorial(index):
	play(str(index))
	explanation.text=explanationText[index]
	header.text=titleText[index]
