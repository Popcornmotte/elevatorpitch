extends Node2D
@export var flip=false
@onready var doorClosedPositionUnflipped=Vector2(32,-16)
@onready var doorClosedPositionFlipped=Vector2(-44,-16)
@onready var doorOpenedPositionUnflipped=Vector2(-32,-16)
@onready var doorOpenedPositionFlipped=Vector2(32,-16)
const DOOROPEN = preload("res://Assets/Audio/sfx/door_open.wav")
var isDoor=true#only needed to check for door

func _ready():
	$DoorClosedSprite.flip_h=flip
	$DoorOpenedSprite.flip_h=flip
	$DoorClosedSprite.visible=true
	$DoorOpenedSprite.visible=false
	
func openDoor():
	$DoorClosedSprite.visible=false
	$DoorOpenedSprite.visible=true
	$LimitPlayerWithDoorStaticBody/CollisionShape2D.set_deferred("disabled",true)
	Audio.playSfx(DOOROPEN)

func closeDoor():
	$DoorClosedSprite.visible=true
	$DoorOpenedSprite.visible=false
	$LimitPlayerWithDoorStaticBody/CollisionShape2D.set_deferred("disabled",false)
