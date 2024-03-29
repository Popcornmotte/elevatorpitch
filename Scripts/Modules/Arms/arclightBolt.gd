extends Line2D

const bolt0 = preload("res://Assets/Audio/sfx/modules/arcBolt0.wav")
const bolt1 = preload("res://Assets/Audio/sfx/modules/arcBolt1.wav")
const bolt2 = preload("res://Assets/Audio/sfx/modules/arcBolt2.wav")
const spark = preload("res://Assets/Audio/sfx/modules/arcFail.wav")

const audio = [bolt0, bolt1, bolt2]

var maxCharge = 1000
var charge = -1
var linePoints : PackedVector2Array
var widths : Array[float]
var exemptEnemies : Array[Enemy]
var fizzleOutTimer = 1.0
var shot = false
var maxDist = 512

func _process(delta):
	if shot:
		if fizzleOutTimer > 0:
			width = lerp(0, 32, fizzleOutTimer)
			fizzleOutTimer -= delta
		else:
			call_deferred("queue_free")
	else:
		if charge == 0:
			call_deferred("queue_free")
			return
		if charge > 0:
			shot = true
			Audio.playSfxLocalized(spark, global_position)
			if Global.aliveEnemies == 0:
				$Fail.play()
			else:
				performSearch(null, global_position)
				finalize()
				if linePoints.size() > 1:
					Audio.playSfxLocalized(audio.pick_random(), global_position)
	pass


func performSearch(startEnemy, previousPos : Vector2):
	var startPos = global_position
	if startEnemy:
		exemptEnemies.push_back(startEnemy)
		startPos = startEnemy.global_position
	
	var reachDist = maxDist * (charge/maxCharge)
	var nextEnemy = findNearestEnemy(startPos)
	if !startEnemy and (!nextEnemy or startPos.distance_to(nextEnemy.global_position) > reachDist):
		$Fail.play()
		return
	
	if startEnemy:
		var chargeLost = min(startEnemy.hitPoints, min(charge, 100))
		if !nextEnemy or startPos.distance_to(nextEnemy.global_position) > reachDist:
			chargeLost = charge
		
		charge -= chargeLost
		
		var dist = previousPos.distance_to(startEnemy.global_position) / maxDist
		var damage = float(chargeLost) / max(dist, 1.0)
		#print("Charge lost: " + str(chargeLost) + ". Dealing " + str(damage) + " damage to " + startEnemy.name)
		startEnemy.takeDamage(damage, 4)
		
	linePoints.push_back(startPos - global_position)
	widths.push_back(charge/maxCharge)
	
	if charge > 0 and exemptEnemies.size() < Global.enemies.size():
		performSearch(nextEnemy, startPos)
	pass
	
func finalize():
	points = linePoints
	var stepSize = 1.0/widths.size()
	var step = 0.0
	for value in widths:
		width_curve.add_point(Vector2(step,value))
		step += stepSize
	width_curve.add_point(Vector2(1,0))
	
func findNearestEnemy(point : Vector2):
	var closestDist = 100000.0
	var closestEnemy : Enemy
	
	for enemy in Global.enemies:
		if enemy not in exemptEnemies:
			var dist = point.distance_to(enemy.global_position)
			if dist < closestDist:
				closestDist = dist
				closestEnemy = enemy
	return closestEnemy
