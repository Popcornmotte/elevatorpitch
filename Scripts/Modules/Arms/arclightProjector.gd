extends GenericArmModule

const boltPrefab = preload("res://Scenes/Objects/Modules/Arms/arclightBolt.tscn")
const failNoise = preload("res://Assets/Audio/sfx/modules/arcFail.wav")

@export var chargeCurve : Curve
var maxChargeTime = 2.0
var chargeTime = 0.0

func activate():
	if Global.countItem(Item.TYPE.Ammo) == 0:
		$FailParticles.set_emitting(true)
		Audio.playSfxLocalized(failNoise, global_position)
		return
	
	active = true
	parent.claw.setGrabLock(true, false)
	$Charge.visible = true
	$Audio.play()

func deactivate():
	if !active:
		return
	active = false
	parent.claw.setGrabLock(false, false)
	$Charge.scale = Vector2(0.5,0.5)
	$Charge.visible = false
	$Audio.stop()
	
	var bolt = boltPrefab.instantiate()
	Global.level.add_child(bolt)
	bolt.global_position = $Charge.global_position
	bolt.charge = chargeTime * 500
	Global.takeFromInventory(Item.TYPE.Ammo)
	
	chargeTime = 0.0

func _process(delta):
	super(delta)
	if active:
		if chargeTime < maxChargeTime:
			chargeTime += delta
		$Charge.scale = Vector2(0.5,0.5) + Vector2(0.5,0.5) * chargeCurve.sample(chargeTime / maxChargeTime)
		$Audio.volume_db = lerpf(-8.0, 4.0, (chargeTime / maxChargeTime))
	pass
