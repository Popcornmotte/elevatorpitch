extends Enemy

const POP = preload("res://Assets/Audio/sfx/pop.wav")
const THUD = preload("res://Assets/Audio/sfx/metal_thud.wav")
const IDK = preload("res://Assets/Audio/sfx/frenchBot.wav")

@export var balloon : Node2D
@export var balloonShape : Node2D
var popped = false



# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	if !rangedBehavior:
		$Crate.set_enabled(false)
	$BalloonSprite.play("default")
	$BodySprite.play("default") 



func flip(dir):
	super(dir)
	$BalloonSprite.flip_h = dir
	$BodySprite.flip_h = dir

func die():
	super()
	if has_node("PinJoint2D"):
		$PinJoint2D.queue_free()
	Audio.playSfx(POP)
	FX.playFX("popsplosion", global_position + Vector2(0,-32))
	popped = true
	if balloon != null:
		balloon.queue_free()
	if balloonShape != null:
		balloonShape.queue_free()




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)


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
