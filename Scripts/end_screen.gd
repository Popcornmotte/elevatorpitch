extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.ending == 0:
		$MarginContainer/Label.text = "You retired on Elysium station. 
		You will enjoy a life of luxury while looking down at your former comrade in the lower class."
	elif Global.ending == 1:
		$MarginContainer/Label.text = "Elysium, the ivory throne of the ruling capitalists, was destroyed and not entirely undue to your efforts.
		A phase of anarchy will follow, but the people are free and equal again. What follows after that only the future knows."
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
