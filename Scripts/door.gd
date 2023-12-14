extends Node2D
@export var flip=false
@onready var doorClosedPositionUnflipped=Vector2(32,-16)
@onready var doorClosedPositionFlipped=Vector2(-44,-16)
@onready var doorOpenedPositionUnflipped=Vector2(-32,-16)
@onready var doorOpenedPositionFlipped=Vector2(32,-16)

func _ready():
	$DoorClosedSprite.flip_h=flip
	$DoorOpenedSprite.flip_h=flip
	
func openDoor():
	$DoorClosedSprite.visible=false
	$DoorOpenedSprite.visible=true
	print("disable")
	$LimitPlayerWithDoorStaticBody/CollisionShape2D.set_deferred("disabled",true)

func closeDoor():
	$DoorClosedSprite.visible=true
	$DoorOpenedSprite.visible=false
	$LimitPlayerWithDoorStaticBody/CollisionShape2D.set_deferred("disabled",false)
