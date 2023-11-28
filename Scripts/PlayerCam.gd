extends Camera2D


# Get a reference to the AnimationPlayer, which is a child of the camera.
@onready var anim = $AnimationPlayer

func zoomIn(state : bool):
	if state:
		anim.play("zoom_in")
		#zoomIn=false
	else:
		anim.play("zoom_out")
		#zoomIn=true
	pass

