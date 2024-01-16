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
@export var weaponFireSound : AudioStream
@export var weaponReloadSound : AudioStream
@export var projectileSpeed : float
@export var weaponNozzle : Node2D
@onready var colShapePosX = $MeleeArea/CollisionShape2D.position.x
var nozzlePosX
#is elevator in melee range?
var elevatorBodyInRange : bool
var playerBody = null
#trajectory for ranged attacks
var trajectory : Vector2
var flipped = false

func _ready():
	if ranged:
		nozzlePosX = $Nozzle.position.x

func flipH(arg : bool):
	$Sprite.set_flip_h(arg)
	flipped = arg
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
	if $Sprite is AnimatedSprite2D:
		$Sprite.play("fire")
	$ReloadTimer.start(reloadTime - 1)
	var projectileInstance = projectile.instantiate()
	get_parent().get_parent().get_parent().add_child(projectileInstance)
	projectileInstance.velocity = get_parent().get_parent().linear_velocity + trajectory * projectileSpeed
	projectileInstance.global_position = weaponNozzle.global_position
	projectileInstance.flipH(flipped)
	Audio.playSfxLocalized(weaponFireSound, global_position)

func reload():
	if $Sprite is AnimatedSprite2D:
		$Sprite.play("reload")
	if weaponReloadSound:
		Audio.playSfxLocalized(weaponReloadSound, global_position)

func checkMeleeHit() -> bool:
	if playerBody != null:
		playerBody.takeDamage(damage, Global.DMG.Piercing)
	return elevatorBodyInRange

#make sure to set collision mask and layer in a way
#that only elevator parts are registeredja
func _on_melee_area_body_entered(body):
	if(!ranged):
		$Sprite.play("attack")
		if body.name == "HullBody":
			elevatorBodyInRange = true
		if body.name == "player":
			playerBody = body
		pass # Replace with function body.


func _on_melee_area_body_exited(body):
	if(!ranged):
		$Sprite.play("idle")
		if body.name == "HullBody":
			elevatorBodyInRange = false
		if body.name == "player":
			playerBody = null
		pass # Replace with function body.
