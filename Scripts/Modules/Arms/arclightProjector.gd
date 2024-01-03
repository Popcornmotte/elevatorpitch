extends GenericArmModule

@export var chargeCurve : Curve
var maxChargeTime = 2.0
var chargeTime = 0.0

func activate():
	active = true
	parent.claw.setGrabLock(true, false)

func deactivate():
	active = false
	parent.claw.setGrabLock(false, false)
	$Charge.scale = Vector2(0.5,0.5)
	chargeTime = 0.0

func _process(delta):
	super(delta)
	if active:
		chargeTime += delta
		$Charge.scale = Vector2(0.5,0.5) + Vector2(0.5,0.5) * chargeCurve.sample(chargeTime / maxChargeTime)
	pass
