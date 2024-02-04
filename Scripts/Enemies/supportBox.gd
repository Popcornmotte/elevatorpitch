extends Enemy
class_name SupportBox

const BEAM = preload("res://Scenes/Objects/Enemies/weapons/supportBeam.tscn")
const THUD = preload("res://Assets/Audio/sfx/metal_thud.wav")

enum SUPPORT_TYPE {health, damage}

@export var type = SUPPORT_TYPE.health
var enemiesInSelfKillRange : Array[Enemy]
var beams : Array[SupportBeam]

func _ready():
	super()

func _process(delta):
	super(delta)

func flip(dir):
	super(dir)

func die():
	super()
	$BodySprite.play("dead")
	for beam in beams:
		beam.call_deferred("queue_free")
		beams.erase(beam)

func _on_minimum_enemy_range_body_entered(body):
	if not body is SupportBox and body is Enemy:
		enemiesInSelfKillRange.push_back(body)

func _on_minimum_enemy_range_body_exited(body):
	if not body is SupportBox and body is Enemy:
		enemiesInSelfKillRange.erase(body)
		if enemiesInSelfKillRange.size() <= 0:
			die()


func _on_area_of_effect_body_entered(body):
	if body == self or not body is Enemy or body is SupportBox:
		return
	if body is Enemy and body.dead:
		return
	if dead:
		return
	var newBeam = BEAM.instantiate()
	newBeam.parent = $BeamOrigin
	newBeam.target = body
	newBeam.type = type
	add_sibling(newBeam)
	beams.push_back(newBeam)

func _on_area_of_effect_body_exited(body):
	if body == self or not body is Enemy:
		return
	for beam in beams:
		if beam.target == body:
			beam.call_deferred("queue_free")
			beams.erase(beam)
			return

func _on_body_entered(body):
	#physical damage on collision if collision speed high enough
	if(!dead and body.is_class("RigidBody2D")):
		#print("collision with speed: "+str(body.linear_velocity.length()))
		if (body.linear_velocity - linear_velocity).length() > 500.0:
			takeDamage(body.mass * (0.1 * body.linear_velocity.length()),Global.DMG.Bludgeoning)
			#print("damage produced: "+str(0.1 * body.mass * body.linear_velocity.length()))
			Audio.playSfx(THUD)

func targetDied(beam):
	beam.call_deferred("queue_free")
	beams.erase(beam)


func _on_death_check_timer_timeout():
	var alive = 0
	for enemy in enemiesInSelfKillRange:
		if enemy and weakref(enemy).get_ref() and !enemy.dead:
			alive += 1
	if alive <= 0:
		die()
