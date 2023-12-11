extends GenericInteractible

const REPAIR = preload("res://Assets/Audio/sfx/repair.wav")
const REPAIRNEEDED = preload("res://Assets/Audio/sfx/repairNeeded.wav")

@export var repairInterior:bool
@export var mirrorAnimation:bool
@onready var player=Global.player
var collided=false
var sfxRepairing
var sfxRepairNeeded
var repairNeeded=false
var repairing=false

func enable():
	$RepairArea/RepairCollisionShape.set_disabled(false)
	$RepairArea/RepairAnimatedSprite2D.visible=true
	$RepairArea/RepairAnimatedSprite2D.play("repairNeeded")
	if mirrorAnimation:#flip according to bool 
		$RepairAnimatedSprite2D.flip_h=true
	$RepairArea/Sparks.emitting = true
	if(sfxRepairNeeded):
		if(!sfxRepairNeeded.playing):
			sfxRepairNeeded = Audio.playSfx(REPAIRNEEDED,true)
	else:
		sfxRepairNeeded=Audio.playSfx(REPAIRNEEDED,true)

func disable():
	pass
	#$RepairArea/RepairCollisionShape.set_disabled(true)#cannot collide with this area
	#$RepairArea/RepairAnimatedSprite2D.visible=false
	#repairing=false
	#$RepairArea/Sparks.emitting = false
	#sfxRepairNeeded=null
	#
func repair():
	if not repairing:
		$RepairArea/RepairTimer.start()
	if(sfxRepairing):
		if(!sfxRepairing.playing):
			sfxRepairing = Audio.playSfx(REPAIR,true)
	else:
		sfxRepairing=Audio.playSfx(REPAIR,true)
	repairing=true
				
#func _process(delta):
#	if not repairObject.functional:#enable this area
#		$RepairCollisionShape.set_disabled(false)
#		$RepairAnimatedSprite2D.visible=true
#		$RepairAnimatedSprite2D.play("repairNeeded")
#		if mirrorAnimation:#flip according to bool 
#			$RepairAnimatedSprite2D.flip_h=true
#		$Sparks.emitting = true
#		if(sfxRepairNeeded):
#			if(!sfxRepairNeeded.playing):
#				sfxRepairNeeded = Audio.playSfx(REPAIRNEEDED,true)
#		else:
#			sfxRepairNeeded=Audio.playSfx(REPAIRNEEDED,true)
#	else:
#		$RepairCollisionShape.set_disabled(true)#cannot collide with this area
#		$RepairAnimatedSprite2D.visible=false
#		repairing=false
#		$Sparks.emitting = false
#		sfxRepairNeeded=null
#		
#	if player:
#		if collided and Input.is_action_pressed("interact") and player.carryingScrap:
#				if not repairing:
#					$RepairTimer.start()
#				if(sfxRepairing):
#					if(!sfxRepairing.playing):
#						sfxRepairing = Audio.playSfx(REPAIR,true)
#				else:
#					sfxRepairing=Audio.playSfx(REPAIR,true)
#				repairing=true
#				

func _on_body_entered(body):
	if body.name=="player":
		Global.player.startRepair=true #disable player dropping scrap when reparing
		if repairing:
			$RepairArea/RepairTimer.set_paused(false)


func _on_body_exited(body):
	if body.name=="player":
		Global.player.startRepair=false 
		if repairing:
			$RepairArea/RepairTimer.set_paused(true)
		


func _on_repair_timer_timeout():
	repairNeeded=true
	player.removeScrap()
	repairing=false
