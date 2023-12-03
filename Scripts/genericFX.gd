extends AnimatedSprite2D


func playFX(trackName : String):
	play(trackName)
	pass

func _on_animation_finished():
	queue_free()
	pass # Replace with function body.
