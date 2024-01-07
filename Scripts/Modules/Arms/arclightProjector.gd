extends GenericArmModule

const boltPrefab = preload("res://Scenes/Objects/Modules/Arms/arclightBolt.tscn")

@export var chargeCurve : Curve
var maxChargeTime = 2.0
var chargeTime = 0.0

func activate():
	active = true
	parent.claw.setGrabLock(true, false)
	$Charge.visible = true
	$Audio.play()

func deactivate():
	active = false
	parent.claw.setGrabLock(false, false)
	$Charge.scale = Vector2(0.5,0.5)
	$Charge.visible = false
	$Audio.stop()
	
	var bolt = boltPrefab.instantiate()
	Global.level.add_child(bolt)
	bolt.global_position = $Charge.global_position
	bolt.charge = chargeTime * 100
	
	chargeTime = 0.0

func _process(delta):
	super(delta)
	if active:
		if chargeTime < maxChargeTime:
			chargeTime += delta
		$Charge.scale = Vector2(0.5,0.5) + Vector2(0.5,0.5) * chargeCurve.sample(chargeTime / maxChargeTime)
		$Audio.volume_db = lerpf(-8.0, 4.0, (chargeTime / maxChargeTime))
	pass
