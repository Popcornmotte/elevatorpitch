extends RigidBody2D

@export var target : Node2D
@export var speed = 10

func _process(delta):
	var dir = target.global_position - global_position
	var dist = dir.length()
	dir = dir.normalized() * min(speed, dist)
	dir /= delta
	linear_velocity = dir * 0.7
	pass
