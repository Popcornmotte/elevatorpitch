extends Area2D

var sprite : Node2D
var velocity = Vector2(0,0)
var damage = 4
var isProjectile = true

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node("AnimatedSprite2D")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity += delta * Vector2(0,9.81)
	position += velocity * delta
	
	var angle = -velocity.normalized().dot(Vector2(0,1))
	sprite.rotation = angle
	
	if(global_position.length() > 1000):
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
			body.owner.takeDamage(damage, Global.DMG.Piercing)
	else:
		if body.has_method("takeDamage"):
			print("I hit this: "+str(body.name))
			body.takeDamage(damage,Global.DMG.Piercing)
