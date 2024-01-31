extends Enemy
class_name SupportBox

const BEAM = preload("res://Scenes/Objects/Enemies/weapons/supportBeam.tscn")
const THUD = preload("res://Assets/Audio/sfx/metal_thud.wav")

enum SUPPORT_TYPE {health, damage}

@export var type = SUPPORT_TYPE.health
var enemiesInSelfKillRange = 0
var beams : Array[SupportBeam]

func _ready():
	print("support box spawned")
	super()

func _process(delta):
	super(delta)

func flip(dir):
	super(dir)

func die():
	print("support box killed")
	super()

func _on_minimum_enemy_range_body_entered(body):
	if body == self or body is Enemy:
		enemiesInSelfKillRange += 1

func _on_minimum_enemy_range_body_exited(body):
	if body == self or body is Enemy:
		enemiesInSelfKillRange -= 1


func _on_area_of_effect_body_entered(body):
	if body == self or not body is Enemy:
		return
	print("New enemy in range: " + body.name)
	var newBeam = BEAM.instantiate()
	newBeam.parent = self
	newBeam.target = body
	newBeam.type = type
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
	if(body.is_class("RigidBody2D")):
		#print("collision with speed: "+str(body.linear_velocity.length()))
		if (body.linear_velocity - linear_velocity).length() > 500.0:
			takeDamage(body.mass * (0.1 * body.linear_velocity.length()),Global.DMG.Bludgeoning)
			#print("damage produced: "+str(0.1 * body.mass * body.linear_velocity.length()))
			Audio.playSfx(THUD)
