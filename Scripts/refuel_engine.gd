extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$RefuelEngineOpen.visible=false
	$RefuelEngineNormal.visible=true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_refuel_engine_area_2d_body_entered(body):
	pass # Replace with function body.
