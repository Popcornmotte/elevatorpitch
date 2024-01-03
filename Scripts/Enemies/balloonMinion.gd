extends Enemy

const POP = preload("res://Assets/Audio/sfx/pop.wav")
const THUD = preload("res://Assets/Audio/sfx/metal_thud.wav")
const IDK = preload("res://Assets/Audio/sfx/frenchBot.wav")

@export var balloon : Node2D
@export var balloonShape : Node2D

#possible stolen loot to take away
var loot



# Called when the node enters the scene tree for the first time.
func _ready():
	$BalloonSprite.play("default")
	$BodySprite.play("default")
	if(has_node("DeathTimer")):
		$DeathTimer.set_wait_time(despawnOnScreenExitTimer)
	if(has_node("$AttackTimer")):
		$AttackTimer.one_shot = true
		$AttackTimer.set_wait_time(weapon.reloadTime * attacksPerTurn)  



func flip(dir):
	super(dir)
	print("Iam called!")
	$BalloonSprite.flip_h = dir
	$BodySprite.flip_h = dir

#called by the claw when grabbed. Will effectivly destory this minion
#so it can be used as a throwable
func grab(clawA):
	clawArea = clawA
	grabbed = true
	set_collision_layer_value(1,false)
	set_collision_mask_value(1,false)
	#remove Layer 3 collision as fix to not get stuck on arm with violent throws
	set_collision_layer_value(3,false)
	set_collision_mask_value(3,false)
	if !popped:
		pop()

func pop():
	if !popped:
		if has_node("PinJoint2D"):
			$PinJoint2D.queue_free()
		Global.aliveEnemies -= 1
		gravity_scale = 1
		Audio.playSfx(POP)
		FX.playFX("popsplosion", global_position + Vector2(0,-32))
		popped = true
		balloon.queue_free()
		balloonShape.queue_free()

	pass
func release(linVel):
	grabbed = false
	linear_velocity = linVel
	set_collision_layer_value(1,true)
	set_collision_mask_value(1,true)
	gravity_scale = 1

func takeDamage(damage):
	var factor
	hitPoints -= damage
	pass

func stealCargo():
	if(Global.checkForCargo()):
		var lootPath = Global.takeFromInventory(Item.TYPE.Cargo).getObjectInstance()
		$Crate.visible = true
		$Crate.mass = 5
		state = STATE.Fleeing
		Audio.playSfx(IDK)
		chooseTarget()
		Global.aliveEnemies -= 1
		return
		#print("loot is null!! what? lets print it: "+str(loot))

func move(delta) -> bool:
	if(!popped):
		if rangedBehavior && global_position.distance_to(target) < 10:
			return false
		if(!weapon.checkMeleeHit() || state == STATE.Repositioning):
			angular_velocity = -rotation * 100 * delta
			var direction = global_position.direction_to(target).normalized()
			speed = lerpf(linear_velocity.length(),maxSpeed,0.5)
			linear_velocity = direction * speed
			if(state == STATE.Repositioning && global_position.distance_to(target) <= 10):
				state = STATE.Attacking
				chooseTarget()
			return true
	if(grabbed):
		return false
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(DebugMode && dbm == null):
		var debugmarker = load("res://Scenes/UI/debug_marker.tscn")
		dbm = debugmarker.instantiate()
		get_parent().add_child(dbm)
		dbm.global_position = target
	
	if(hitPoints <=0 ):
		dead = true
		pop()
	
	if(reload>0):reload-=delta
	
	move(delta)
	
	if !popped:
		if rangedBehavior:
			if global_position.distance_to(target) <= 10:
				if (reload<=0):
					weapon.fire(global_position.direction_to(elevatorPos).normalized())
					reload = weapon.reloadTime
		else:
			if(weapon.checkMeleeHit() && state == STATE.Attacking):
				if $AttackTimer.time_left == 0:
					$AttackTimer.start()
				if (reload<=0):
					Global.elevator.takeDamage(weapon.damage)
					Audio.playSfx(weapon.weaponSound)
					if(attacksStealCargo):
						if(randi()%100 <= stealChancePercent):
							stealCargo()
					reload = weapon.reloadTime

func _on_visible_on_screen_notifier_2d_screen_exited():
	if popped || state == STATE.Fleeing:
		$DeathTimer.start()
	pass # Replace with function body.


func _on_death_timer_timeout():
	
	if(dbm != null):
		dbm.queue_free()
	call_deferred("queue_free")
	pass # Replace with function body.

#AttackTimer needs to be OneShot = true!
func _on_attack_timer_timeout():
	if state != STATE.Fleeing:
		state = STATE.Repositioning
	chooseTarget()
	pass # Replace with function body.

#Contact-Monitor needs to be set to true for this signal to work
#Max_Contact_Reports also needs to be greater than 0
func _on_body_entered(body):
	#physical damage on collision if collision speed high enough
	if(body.is_class("RigidBody2D")):
		#print("collision with speed: "+str(body.linear_velocity.length()))
		if (body.linear_velocity - linear_velocity).length() > 500.0:
			hitPoints -= body.mass * (0.1 * body.linear_velocity.length())
			#print("damage produced: "+str(0.1 * body.mass * body.linear_velocity.length()))
			Audio.playSfx(THUD)
	pass # Replace with function body.
