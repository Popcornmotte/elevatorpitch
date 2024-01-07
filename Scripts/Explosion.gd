extends DeleteSelf

@export var damage = 150.0
var dealtDamageTo = []
const BOOM = preload("res://Assets/Audio/sfx/explosion.wav")

func _ready():
	Audio.playSfx(BOOM)
	
func onAreaEntered(other : Node2D):
	print("Checking " + other.name)
	if dealtDamageTo.has(other):
		# To make sure we dont damage something twice (like the elevator)
		return
	if other.has_method("takeDamage"):
		var distanceFactor = max(0,(global_position.distance_to(other.global_position) - 150))
		distanceFactor /= 100
		distanceFactor = 1/(distanceFactor+1)
		other.takeDamage(damage * distanceFactor, Global.DMG.Force)
		dealtDamageTo.push_back(other)
		print("Dealt " + str(damage * distanceFactor) + " to " + other.name)
	elif other.get_parent() != null:
		print(other.name + " didnt have takeDamage.")
		onAreaEntered(other.get_parent())


func _on_animated_sprite_2d_animation_finished():
	queue_free()
	pass # Replace with function body.
