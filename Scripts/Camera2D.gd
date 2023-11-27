extends Camera2D


# Get a reference to the AnimationPlayer, which is a child of the camera.
@onready var anim = $AnimationPlayer
var playing=false
var zoomOut=false

func _process(delta):
	if Input.is_action_just_pressed("zoom_in") and not playing and not zoomOut:
		anim.play("zoom_in")
		zoomOut=true
	if Input.is_action_just_pressed("zoom_out") and not playing and  zoomOut:
		anim.play("zoom_out")
		zoomOut=false


func _on_animation_player_animation_finished(anim_name):
	playing=false


func _on_animation_player_animation_started(anim_name):
	playing=true
