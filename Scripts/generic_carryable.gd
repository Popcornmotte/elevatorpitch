extends RigidBody2D

@export var type : Item.TYPE
var pushForce=2
func onAreaEntered(body):
	if body.name == "player":
		Global.player.addCarryable(self)
		if !Global.tutorialsCompleted[1]:
			Global.elevator.startFuelTutorial()
			
#func collideWithRigidbodies():
#	var collisions=get_colliding_bodies()
#	for i in collisions.size():
#		var c=collisions[i]
#		print ("colliding")
#		if c.get_collider() is RigidBody2D:
#			c.get_collider().apply_central_impulse(-c.get_normal()*pushForce)
			
#func _process(delta):
#	collideWithRigidbodies()
	
func onAreaExit(body):
	if body.name == "player":
		Global.player.removeCarryable(self)

func getType():
	return type
