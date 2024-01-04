extends Line2D

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
			if Global.aliveEnemies == 0:
				$Fail.play()
			else:
				performSearch(null, global_position)
				finalize()
	pass


func performSearch(startEnemy, previousPos : Vector2):
	var startPos = global_position
	if startEnemy:
		exemptEnemies.push_back(startEnemy)
		startPos = startEnemy.global_position
	
	var nextEnemy = findNearestEnemy(startPos)
	if !startEnemy and startPos.distance_to(nextEnemy.global_position) > maxDist:
		$Fail.play()
		return
	
	if startEnemy:
		var chargeLost = min(startEnemy.hitPoints, min(charge, 100))
		if !nextEnemy or startPos.distance_to(nextEnemy.global_position) > maxDist:
			chargeLost = charge
		
		charge -= chargeLost
		
		var dist = previousPos.distance_to(startEnemy.global_position) / maxDist
		var damage = float(chargeLost) / max(dist, 1.0)
		print("Charge lost: " + str(chargeLost) + ". Dealing " + str(damage) + " damage to " + startEnemy.name)
		startEnemy.takeDamage(damage, 4)
		
	linePoints.push_back(startPos - global_position)
	widths.push_back(charge/200)
	
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
