extends GenericArmModule

@export var cooldown = 2.0

func activate():
	active = true
	$Text.text = "Active"
	$Parry.play()
	$ShieldSprite.visible = true
	pass

func deactivate():
	active = false
	$Text.text = "Inactive"
	$ShieldSprite.visible = false

func _process(delta):
	super(delta)

func _on_area_entered(area):
	blockProjectiles(area)
	pass # Replace with function body.

func _on_body_entered(body):
	blockProjectiles(body)
	pass # Replace with function body.

func blockProjectiles(projectile):
	if "isProjectile" in projectile and projectile.isProjectile:
		projectile.velocity = -projectile.velocity
