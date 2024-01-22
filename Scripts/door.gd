extends Node2D
@export var flip=false
@onready var doorClosedPositionUnflipped=Vector2(32,-16)
@onready var doorClosedPositionFlipped=Vector2(-44,-16)
@onready var doorOpenedPositionUnflipped=Vector2(-32,-16)
@onready var doorOpenedPositionFlipped=Vector2(32,-16)
const DOOROPEN = preload("res://Assets/Audio/sfx/door_open.wav")
var isDoor=true#only needed to check for door
var jetpackToggle = true

func _ready():
	$DoorClosedSprite.flip_h=flip
	$DoorOpenedSprite.flip_h=flip
	$DoorClosedSprite.visible=true
	$DoorOpenedSprite.visible=false
	if flip:
		$JetpackOnArea.position.x *= -1
		$JetpackOffArea.position.x *= -1
	if Global.level == null:
		jetpackToggle = false

func openDoor():
	$DoorClosedSprite.visible=false
	$DoorOpenedSprite.visible=true
	$LimitPlayerWithDoorStaticBody/CollisionShape2D.set_deferred("disabled",true)
	Audio.playSfx(DOOROPEN)

func closeDoor():
	$DoorClosedSprite.visible=true
	$DoorOpenedSprite.visible=false
	$LimitPlayerWithDoorStaticBody/CollisionShape2D.set_deferred("disabled",false)


func _on_jetpack_on_area_body_entered(body):
	if jetpackToggle:
		if body.name == "player":
			body.toggleJetpack(true)
	pass # Replace with function body.


func _on_jetpack_off_area_body_entered(body):
	if jetpackToggle:
		if body.name == "player":
			body.toggleJetpack(false)
	if body.name == "player":
		print("dispenser tutorial ",Global.TUTORIAL_INDICES.DISPENSER, Global.animatedTutorialsCompleted[Global.TUTORIAL_INDICES.DISPENSER])
		Global.optionsMenu.switch(Global.TUTORIAL_INDICES.DISPENSER)
	pass # Replace with function body.
