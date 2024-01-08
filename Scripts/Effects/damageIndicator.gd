extends Node2D
class_name DamageIndicator

var parent : Node2D
var timeSinceUpdate = 0.0
var fadeTime = 3.0
var damage = 0

func _ready():
	$Animation.play("scale")
	
func _process(delta):
	global_position += Vector2(0,-64) * delta
	timeSinceUpdate += delta
	set_modulate(Color(1,1,1,1).lerp(Color(1,1,1,0), timeSinceUpdate/fadeTime))
	
	if timeSinceUpdate > fadeTime:
		call_deferred("queue_free")

func addDamage(dealt:int):
	if dealt == 0:
		return
	timeSinceUpdate = 0
	damage += dealt
	if damage > 0:
		$Text.text = "[center][color=#FF2000]-" + str(damage) + "[/color][/center]"
	else:
		$Text.text = "[center][color=#20FF00]+" + str(damage) + "[/color][/center]"
	$Animation.play("scale")

func _on_cutoff_timer_timeout():
	if parent and weakref(parent).get_ref():
		parent.damageIndicator = null
