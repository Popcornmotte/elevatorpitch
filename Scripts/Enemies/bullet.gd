extends Area2D

var sprite : Node2D
var velocity = Vector2(0,0)
@export var damage = 4
@export var ignoreEnemies = false
@export var explodeOnImpact = false
var Explosion
var isProjectile = true
var origin : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	if explodeOnImpact:
		Explosion = load("res://Scenes/Objects/explosion.tscn")
	sprite = get_node("AnimatedSprite2D")
	pass # Replace with function body.

func flipH(arg : bool):
	$AnimatedSprite2D.flip_h = arg

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#velocity += delta * Vector2(0,9.81)
	position += velocity * delta
	 
	rotation = -velocity.normalized().dot(Vector2(0,1))
	if(global_position.length() > 2000):
		queue_free()
	pass

#Self-destruct after timeout
func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.


func _on_body_entered(body):
	if body.owner != null:
		if body.owner.name == "Elevator":
			#print("Bullet found its target")
			if explodeOnImpact:
				var explosion =  Explosion.instantiate()
				get_parent().add_child(explosion)
				explosion.global_position = global_position
				call_deferred("queue_free")
			else:
				body.owner.takeDamage(damage, Global.DMG.Piercing)
	elif !ignoreEnemies:
		if body.has_method("takeDamage"):
			#print("I hit this: "+str(body.name))
			if explodeOnImpact:
				var explosion =  Explosion.instantiate()
				get_parent().add_child(explosion)
				explosion.global_position = global_position
				call_deferred("queue_free")
			else:
				body.takeDamage(damage,Global.DMG.Piercing)
