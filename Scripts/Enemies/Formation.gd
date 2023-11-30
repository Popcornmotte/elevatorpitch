extends Node2D

# Reparent all Enemies to parent scene, then commit suicide
func _ready():
	for child in get_children():
		child.reparent(get_parent(),true)
	call_deferred("queue_free")
