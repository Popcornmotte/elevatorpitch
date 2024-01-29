extends GenericDestroyable

var interactable = true

func _on_area_2d_body_entered(body):
	$Desk.play("lit")
	$Hint.visible = true

func _on_area_2d_body_exited(body):
	$Desk.play("default")
	$Hint.visible = false

func use():
	get_tree().change_scene_to_file("res://Scenes/UI/base_ui.tscn")
