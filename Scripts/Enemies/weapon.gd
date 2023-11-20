extends Node2D

class_name Weapon


#how much damage when it hits?
@export var damage : int
#how long is the cooldown between hits in seconds?
@export var reloadTime : float
#is the wepon ranged or melee?
@export var ranged = false
#if ranged, what projectile to fire
@export var projectile : PackedScene
@export var projectileSpeed : float

#is elevator in melee range?
var elevatorBodyInRange : bool
#trajectory for ranged attacks
var trajectory : Vector2

func fire(trajectory):
	var projectileInstance = projectile.instantiate()
	get_parent().get_parent().get_parent().add_child(projectileInstance)
	projectileInstance.velocity = get_parent().get_parent().linear_velocity + trajectory * projectileSpeed
	projectileInstance.position = global_position
	

func checkMeleeHit() -> bool:
	return elevatorBodyInRange

#make sure to set collision mask and layer in a way
#that only elevator parts are registered
func _on_melee_area_body_entered(body):
	elevatorBodyInRange = true
	pass # Replace with function body.


func _on_melee_area_body_exited(body):
	elevatorBodyInRange = false
	pass # Replace with function body.
