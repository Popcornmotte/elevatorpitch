extends Node
class_name CustomParallaxLayer

@export var movementFactor = 1.0
@export var cloudSpeed = 50.0
@onready var children = get_children()
var maxCloudHeight : float
var isCanvas = false

func _ready():
	isCanvas = get_child(0).get_parent() is CanvasLayer

func _process(delta):
	if Global.elevator.moving:
		print("Climb environment moving")
		if isCanvas:
			self.offset.y = movementFactor * Global.height * 100
		else :
			self.global_position.y = movementFactor * Global.height * 100
		for child in children:
			var respawn = true
			respawn = respawn && !is_in_group("Earth")
			respawn = respawn && (!is_in_group("Clouds") or Global.height <= maxCloudHeight)
			if respawn && (child.global_position.y > 1000):
				child.global_position.y -= 2000
			
			if is_in_group("Clouds"):
				child.global_position.x += delta * cloudSpeed
				if (cloudSpeed > 0 && child.global_position.x > 1500) or (cloudSpeed < 0 && child.global_position.x < -1500):
					child.global_position.x -= 3000 * sign(cloudSpeed)
	
