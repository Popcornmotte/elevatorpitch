extends Node2D
class_name Elevator

var health = 100
var fuel = 100.0
var lost = false
var speed = 0.0

@export var healthBar : Node2D
@export var fuelBar : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func on_area_entered(area : Area2D):
	if(area.damage != null):
		health -= area.damage
		update_health()
	pass

func update_health():
	if(!lost):
		if(health <= 0):
			# Lose
			lost = true
			speed = 150
			pass
		healthBar.scale = Vector2(health / 100.0, 1)
	pass

func decrease_fuel(delta):
	fuel -= delta
	update_fuel()
	pass

func update_fuel():
	fuelBar.scale = Vector2(fuel / 100.0, 1)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(lost):
		position -= Vector2(0,speed * delta)
		speed -= 400 * delta
	pass
