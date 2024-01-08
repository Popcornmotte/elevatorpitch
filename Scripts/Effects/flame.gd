extends Node

@export var damagePerTimeout = 10
var parent : Node2D

func restartTimer():
	$Lifetime.start()

func _on_damage_timer_timeout():
	parent.takeDamage(damagePerTimeout, 3)

func _on_lifetime_timeout():
	call_deferred("queue_free")
