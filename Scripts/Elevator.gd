extends Node2D
class_name Elevator

var health = 100
var fuel = 100.0
var lost = false
var speed = 0.0

@export var healthBar : Node2D
@export var fuelBar : Node2D

func _enter_tree():
	Global.elevator = self

# Called when the node enters the scene tree for the first time.
func _ready():
	$HullBody/AnimationPlayer.play("EngineJiggle")
	pass # Replace with function body.

func takeDamage(damage:int):
	health -= damage
	update_health()
	pass

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
	
#	if(get_local_mouse_position().y < 0):
#		$Skeleton2D.get_modification_stack().get_modification(0).set_ccdik_joint_constraint_angle_invert(2,true)
#	else:
#		$Skeleton2D.get_modification_stack().get_modification(0).set_ccdik_joint_constraint_angle_invert(2,false)
	if(lost):
		position -= Vector2(0,speed * delta)
		speed -= 400 * delta
	pass


func _on_engine_sound_finished():
	$HullBody/EngineSound.play()
	pass # Replace with function body.
