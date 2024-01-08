extends Sprite2D

@export var factorH = 0.0
@export var factorV = 0.0
@export var HEqualsV = true

@onready var startPos = get_global_transform_with_canvas().origin

func _ready():
	if HEqualsV:
		factorV = factorH

func _process(delta):
	var pos = get_global_transform_with_canvas().origin - startPos
	offset = -Vector2(pos.x * factorH, pos.y * factorV) / 6
	pass
