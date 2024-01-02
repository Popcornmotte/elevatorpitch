extends Area2D

var linear_velocity
@export var sizeCurve : Curve

func _on_body_entered(body):
	if "intersectingFlameParticles" in body:
		body.intersectingFlameParticles += 1
		body.takeDamage(5)
	pass # Replace with function body.


func _on_body_exited(body):
	if "intersectingFlameParticles" in body:
		body.intersectingFlameParticles -= 1
	pass # Replace with function body.

func _on_timeout():
	call_deferred("queue_free")

func _ready():
	var time = $Timer.time_left / $Timer.wait_time
	scale = Vector2(1,1) * sizeCurve.sample(1 - time)

func _process(delta):
	linear_velocity = linear_velocity * (1-delta)
	global_position += linear_velocity * delta
	var time = $Timer.time_left / $Timer.wait_time
	scale = Vector2(1,1) * sizeCurve.sample(1 - time)
