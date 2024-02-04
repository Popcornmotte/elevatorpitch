extends Enemy

const THUD = preload("res://Assets/Audio/sfx/metal_thud.wav")

func die():
	super()
	$BodySprite.play("dead")
	weapon.abort()

#Contact-Monitor needs to be set to true for this signal to work
#Max_Contact_Reports also needs to be greater than 0
func _on_body_entered(body):
	#physical damage on collision if collision speed high enough
	if(body.is_class("RigidBody2D")):
		#print("collision with speed: "+str(body.linear_velocity.length()))
		if (body.linear_velocity - linear_velocity).length() > 500.0:
			takeDamage(body.mass * (0.1 * body.linear_velocity.length()),Global.DMG.Bludgeoning)
			#print("damage produced: "+str(0.1 * body.mass * body.linear_velocity.length()))
			Audio.playSfx(THUD)
	pass # Replace with function body.
