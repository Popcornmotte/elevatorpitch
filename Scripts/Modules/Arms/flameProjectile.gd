extends Area2D

var linear_velocity
@export var sizeCurve : Curve
var timeToLive = 0.0

func _on_body_entered(body):
	if "intersectingFlameParticles" in body:
		body.intersectingFlameParticles += 1
		var damage = roundf(timeToLive*5)
		body.takeDamage(damage, 3)
	pass # Replace with function body.


func _on_body_exited(body):
	if "intersectingFlameParticles" in body:
		body.intersectingFlameParticles -= 1
	pass # Replace with function body.

func _on_timeout():
	call_deferred("queue_free")

func _ready():
	timeToLive = $Timer.time_left / $Timer.wait_time
	scale = Vector2(1,1) * sizeCurve.sample(1 - timeToLive)
	$Sprite.frame = randi_range(0,64)

func _process(delta):
	linear_velocity = linear_velocity * (1-delta)
	global_position += linear_velocity * delta
	timeToLive = $Timer.time_left / $Timer.wait_time
	scale = Vector2(1,1) * sizeCurve.sample(1 - timeToLive)
