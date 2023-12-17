extends Node2D

const ROPE = preload("res://Scripts/rope.gd")
var startPos : Vector2
var endPos : Vector2

func _input(event):
	if event == InputEventMouseButton:
		if event.is_pressed():
			startPos = get_global_mouse_position()
		elif event.is_released():
			endPos = get_global_mouse_position()
			var rope = ROPE.instantiate(startPos, endPos)
