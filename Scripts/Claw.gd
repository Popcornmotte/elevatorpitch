extends AnimatableBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func grab():
	pass
	
func release():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("Grab"):
		$ClawSprite.play("close")
	else:
		$ClawSprite.play("open")
		
	if(Input.is_action_just_pressed("Grab")):
		grab()
	
	pass
