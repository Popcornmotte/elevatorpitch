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
@export var weaponSound : AudioStream
@export var projectileSpeed : float
@export var weaponNozzle : Node2D
@onready var colShapePosX = $MeleeArea/CollisionShape2D.position.x
var nozzlePosX
#is elevator in melee range?
var elevatorBodyInRange : bool
#trajectory for ranged attacks
var trajectory : Vector2

func _ready():
	if ranged:
		nozzlePosX = $Nozzle.position.x

func flipH(arg : bool):
	$Sprite.flip_h = arg
	if arg:
		if ranged:
			$Nozzle.position.x = -nozzlePosX
		else:
			$MeleeArea/CollisionShape2D.position.x = -colShapePosX
	else:
		if ranged:
			$Nozzle.position.x = nozzlePosX
		else:
			$MeleeArea/CollisionShape2D.position.x = colShapePosX

func fire(trajectory):
	var projectileInstance = projectile.instantiate()
	get_parent().get_parent().get_parent().add_child(projectileInstance)
	projectileInstance.velocity = get_parent().get_parent().linear_velocity + trajectory * projectileSpeed
	projectileInstance.global_position = weaponNozzle.global_position
	Audio.playSfx(weaponSound)

func checkMeleeHit() -> bool:
	return elevatorBodyInRange

#make sure to set collision mask and layer in a way
#that only elevator parts are registered
func _on_melee_area_body_entered(body):
	if(!ranged):
		$Sprite.play("attack")
		elevatorBodyInRange = true
		pass # Replace with function body.


func _on_melee_area_body_exited(body):
	if(!ranged):
		$Sprite.play("idle")
		elevatorBodyInRange = false
		pass # Replace with function body.
