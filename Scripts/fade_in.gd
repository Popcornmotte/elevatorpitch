extends Node2D

func _ready():
	position = get_viewport().get_camera_2d().get_screen_center_position()-Vector2(960,540)
	#get_viewport().get_camera_2d().get_screen_center_position()
	print("pos is: "+str(position))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$darkness.self_modulate.a -= delta/2
	if($darkness.self_modulate.a <= 0):queue_free()
