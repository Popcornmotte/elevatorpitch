extends GenericArmModule

@export var cooldown = 2.0
var projectilesInRange : Array[Node2D]

func activate():
	active = true
	parent.claw.setGrabLock(true, true)
	$Text.text = "Active"
	$Parry.play()
	$ShieldSprite.visible = true
	pass

func deactivate():
	active = false
	parent.claw.setGrabLock(false, true)
	$Text.text = "Inactive"
	$ShieldSprite.visible = false

func _process(delta):
	super(delta)

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
	for projectile in projectilesInRange:
		projectile.velocity = -projectile.velocity

func blockProjectiles(projectile):
	if "isProjectile" in projectile and projectile.isProjectile:
		projectile.call_deferred("queue_free")
