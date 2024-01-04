extends Node2D

const REVOLVERSOUND = preload("res://Assets/Audio/sfx/revolver.wav")
const HIT = preload("res://Assets/Audio/sfx/panHit.wav")

@onready var ray = $ray
@onready var sprite = $sprite
@export var damage = 200

var enabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	setEnabled(false)
	pass # Replace with function body.

func setEnabled(state):
	enabled = state
	if enabled:
		show()
	else:
		hide()


func shoot():
	if enabled:
		sprite.play("shot")
		Audio.playSfx(REVOLVERSOUND)
		if ray.is_colliding():
			Audio.playSfx(HIT)
			var collider = ray.get_collider()
			if collider.has_method("takeDamage"):
				collider.takeDamage(damage, Global.DMG.Piercing)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mousePos = get_global_mouse_position()
	ray.look_at(mousePos)
	sprite.look_at(mousePos)
	if(mousePos.x < global_position.x):
		sprite.flip_v = true
	else:
		sprite.flip_v = false
	pass
