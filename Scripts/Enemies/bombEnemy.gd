extends Enemy

const THUDS = [preload("res://Assets/Audio/sfx/wood_thud0.wav"), preload("res://Assets/Audio/sfx/wood_thud1.wav"), preload("res://Assets/Audio/sfx/wood_thud2.wav")]

var explosion = preload("res://Scenes/Objects/explosion.tscn")
var engine = preload("res://Scenes/Objects/Enemies/low_bomb_engine.tscn")
var barrel = preload("res://Scenes/Objects/Enemies/low_bomb_barrel.tscn")

func grab(clawA):
	var node = clawA
	while !(node.has_method("disableArm")) && node.get_parent() != null:
		node = node.get_parent()
	if(node.has_method("disableArm")):
		node.disableArm()
	explode()

func release(linVel):
	pass

func takeDamage(damage, type):
	var factor = damageFactors[type]
	hitPoints -= damage * factor
	if(hitPoints<=0):
		explode()

func _on_body_entered(body):
	if(body.is_class("RigidBody2D")):
		if (body.linear_velocity - linear_velocity).length() > 500.0:
			takeDamage(body.mass * (0.1 * body.linear_velocity.length()),Global.DMG.Bludgeoning)
			Audio.playSfx(THUDS.pick_random())

func explode():
	var newExplosion = explosion.instantiate()
	newExplosion.global_position = global_position
	get_parent().call_deferred("add_child",newExplosion)
	
	var newEngine = engine.instantiate()
	newEngine.global_position = global_position
	get_parent().call_deferred("add_child",newEngine)
	
	die()
	pass

func defuse():
	var newEngine = engine.instantiate()
	newEngine.global_position = global_position
	get_parent().call_deferred("add_child",newEngine)
	
	var newBarrel = barrel.instantiate()
	newBarrel.global_position = global_position
	get_parent().call_deferred("add_child",newBarrel)
	
	die()

func die():
	Global.aliveEnemies -= 1
	Global.enemies.erase(self)
	call_deferred("queue_free")
	

func move(delta):
	angular_velocity = -rotation * 100 * delta
	var direction = global_position.direction_to(target).normalized()
	var speed = lerpf(linear_velocity.length(),maxSpeed,0.5)
	linear_velocity = direction * speed

func _on_trigger_area_entered(area):
	explode()
	pass # Replace with function body.
