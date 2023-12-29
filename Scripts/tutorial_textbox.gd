extends Node2D

@export var startVisible = false
# Check "TutorialsCompleted" array in global for index
@export var tutorialIndex = 0

func _ready():
	if startVisible and !Global.tutorialsCompleted[tutorialIndex]:
		call_deferred("show")
	else:
		call_deferred("hide")

func open():
	if !Global.tutorialsCompleted[tutorialIndex]:
		visible = true

func close():
	call_deferred("queue_free")

func on_body_entered(body_rid, body, body_shape_index, local_shape_index):
	open()

func _on_area_2d_body_entered(body):
	open()
