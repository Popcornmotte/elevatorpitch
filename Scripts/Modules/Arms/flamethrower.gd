extends GenericArmModule

const FLAME = preload("res://Scenes/Objects/Modules/Arms/flameProjectile.tscn")
@export var emissionFrequency = 5
@onready var emissionCooldown = 1/emissionFrequency
var cooldown = 0.0
var audioPos = 0.0

func activate():
	if Global.elevator.fuel >= 0:
		active = true
		parent.claw.setGrabLock(true, false)
		$Audio.play()
		$Audio.seek(audioPos)
	
func deactivate():
	active = false
	parent.claw.setGrabLock(false, false)
	audioPos = $Audio.get_playback_position()
	$Audio.stop()

func _process(delta):
	super(delta)
	if active:
		cooldown -= delta
		if cooldown <= 0:
			if Global.elevator.fuel <= 0:
				deactivate()
				return
			Global.elevator.decrease_fuel(delta)
			var forwardVec = $Forward.global_position - global_position
			var particleInstance = FLAME.instantiate()
			Global.level.add_child(particleInstance)
			particleInstance.global_position = global_position + forwardVec
			particleInstance.linear_velocity = forwardVec.normalized().rotated(randf_range(-0.2,0.2)) * 300
			cooldown = emissionCooldown
