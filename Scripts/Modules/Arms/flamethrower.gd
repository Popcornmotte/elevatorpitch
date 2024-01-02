extends GenericArmModule

const FLAME = preload("res://Scenes/Objects/Modules/Arms/flameProjectile.tscn")
@export var emissionFrequency = 5
@onready var emissionCooldown = 1/emissionFrequency

func activate():
	print("Flamethrower activated")
	active = true
	pass
	
func deactivate():
	print("Flamethrower deactivated")
	active = false
	pass

func _process(delta):
	super(delta)
	if active:
		emissionCooldown -= delta
		if emissionCooldown <= 0:
			var forwardVec = $Forward.global_position - global_position
			var particleInstance = FLAME.instantiate()
			Global.level.add_child(particleInstance)
			particleInstance.global_position = global_position + transform.x * 10
			particleInstance.linear_velocity = forwardVec.normalized() * 300
			
