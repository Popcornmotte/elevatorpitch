extends GenericArmModule

const pling = preload("res://Assets/Audio/sfx/modules/shieldPling.wav")
const deflect = preload("res://Assets/Audio/sfx/modules/shieldDeflect.wav")
const absorb = preload("res://Assets/Audio/sfx/modules/arcFail.wav")

@export var cooldown = 2.0
var projectilesInRange : Array[Node2D]
var audioPos = 0.0

func activate():
	active = true
	parent.claw.setGrabLock(true, true)
	$Text.text = "Active"
	$Parry.play()
	$ShieldSprite.visible = true
	$AudioLoop.play()
	$AudioLoop.seek(audioPos)
	$LaserBlocker/CollisionPolygon2D.set_deferred("disabled", false)
	Audio.playSfxLocalized(deflect, global_position)
	repellProjectiles()
	pass

func deactivate():
	active = false
	parent.claw.setGrabLock(false, true)
	$Text.text = "Inactive"
	$ShieldSprite.visible = false
	audioPos = $AudioLoop.get_playback_position()
	$AudioLoop.stop()
	$LaserBlocker/CollisionPolygon2D.set_deferred("disabled", true)

func _process(delta):
	super(delta)
	#if Input.is_action_just_pressed("Debug"):
	#	$AudioDeflect.play()
	#	Audio.playSfx(pling)

func _on_area_entered(area):
	if active:
		blockProjectiles(area)
	elif "isProjectile" in area and area.isProjectile:
		projectilesInRange.push_back(area)

func _on_body_entered(body):
	if active:
		blockProjectiles(body)
	elif "isProjectile" in body and body.isProjectile:
		projectilesInRange.push_back(body)

func _on_area_exited(area):
	if "isProjectile" in area and area.isProjectile:
		projectilesInRange.erase(area)

func _on_body_exited(body):
	if "isProjectile" in body and body.isProjectile:
		projectilesInRange.erase(body)

func repellProjectiles():
	if projectilesInRange.size() > 0:
		Audio.playSfx(pling)
		for projectile in projectilesInRange:
			#projectile.velocity = -projectile.velocity
			projectile.velocity = projectile.velocity.length() * projectile.global_position.direction_to(projectile.origin)
			projectile.ignoreEnemies = false

func blockProjectiles(projectile):
	if "isProjectile" in projectile and projectile.isProjectile:
		Audio.playSfxLocalized(absorb, global_position)
		projectile.call_deferred("queue_free")
