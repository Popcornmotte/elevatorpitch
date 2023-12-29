extends RigidBody2D

var precursorSegment = null

func _draw():
	if precursorSegment != null:
		draw_line(position, precursorSegment.position, Color.BLACK,4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
