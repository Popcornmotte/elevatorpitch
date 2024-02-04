extends Weapon

const LASER_LOOP = preload("res://Assets/Audio/sfx/shots/laserLoop.wav")
const LASER_CHARGE = preload("res://Assets/Audio/sfx/shots/laserCharge.wav")

var shotsPerFire = 3
@onready var shots = shotsPerFire
@onready var chargeMaxWidth = $ChargeBeam.width
var target : Vector2

func fire(trajectory):
	$ChargeTimer.start()
	$RayCast2D.set_target_position(trajectory * 512)
	target = $RayCast2D.get_collision_point()
	$ChargeBeam.visible = true
	Audio.playSfxLocalized(LASER_CHARGE, global_position)

func _on_charge_timer_timeout():
	$ChargeBeam.width = 0
	$ChargeBeam.visible = false
	$FireBeam.visible = true
	$ShotTimer.start()
	Audio.playSfxLocalized(LASER_LOOP, global_position)

func _process(delta):
	if !$ChargeTimer.is_stopped() and $ChargeTimer.time_left > 0:
		var fadeFac = $ChargeTimer.time_left / $ChargeTimer.wait_time
		$ChargeBeam.width = (1-fadeFac) * chargeMaxWidth
	
	if $ChargeTimer.time_left > 0 or $ShotTimer.time_left > 0:
		target = $RayCast2D.get_collision_point()
		var localTarget = to_local(target)
		$ChargeBeam.points[1] = localTarget
		$FireBeam.points[1] = localTarget

func _on_shot_timer_timeout():
	var hit = $RayCast2D.get_collider()
	while hit and !check_hit(hit):
		hit = hit.get_parent()
	shots -= 1
	if shots > 0:
		$ShotTimer.start()
	else:
		$FireBeam.visible = false
		$ReloadTimer.start()
		shots = shotsPerFire
	
func check_hit(object): # returns if shot was absorbed by shield
	if object is Elevator:
		object.takeDamage(damage, 3)
		return false
	elif object is GenericArmModule:
		return true

func abort():
	shots = 0
	$ChargeTimer.stop()
	$ChargeBeam.visible = false
	$FireBeam.visible = false
