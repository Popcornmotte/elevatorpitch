extends Node2D

const ROPE = preload("res://Scenes/Objects/Test/rope.tscn")
var startPos : Vector2
var endPos : Vector2
var pinned = false

func _process(delta):
	if Input.is_action_just_pressed("RightClick"):
		pinned = !pinned
		$Label.text = "Pinned mode "+str(pinned)
	
	if Input.is_action_just_pressed("Grab"):
		print("pressed!")
		startPos = get_global_mouse_position()
	elif Input.is_action_just_released("Grab"):
		print("released!")
		endPos = get_global_mouse_position()
		var rope = ROPE.instantiate()
		
		rope.global_position = startPos
		rope.position = startPos
		add_child(rope)
		rope.spawn(startPos,endPos, pinned)
