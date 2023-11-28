extends Camera2D


# Get a reference to the AnimationPlayer, which is a child of the camera.
@onready var anim = $AnimationPlayer
var playing=false
var zoomIn=true

func _process(delta):
	if Global.elevator:
		# zoom in when not controlling arms and not already playing and not already zoomed in
		if !Global.elevator.controlArms and not playing and zoomIn:
			anim.play("zoom_in")
			zoomIn=false
		# zoom out when controlling arms and not already playing and not already zoomed out	
		if Global.elevator.controlArms and not playing and  not zoomIn:
			anim.play("zoom_out")
			zoomIn=true


func _on_animation_player_animation_finished(anim_name):
	playing=false


func _on_animation_player_animation_started(anim_name):
	playing=true
