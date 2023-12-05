extends Area2D

const REPAIR = preload("res://Assets/Audio/sfx/repair.wav")
const REPAIRNEEDED = preload("res://Assets/Audio/sfx/repairNeeded.wav")
# i know this is ugly, but trying to modify the elevator scene crashes godot consistently for me
@export var repairObject:Node2D
@export var repairInterior:bool
@export var mirrorAnimation:bool
@onready var player=Global.player
var collided=false
var sfxRepairing
var sfxRepairNeeded

var repairing=false
func _ready():
#	if not repairInterior:#in this case we are repairing something at the elevator, not interior, fix for now, to be removed once the elevator scene is fixed
#		repairObject=Global.elevator.get_node(pathToRepair)
#	else:
#		repairObject=get_parent()#repair something in the interior, just add this script to a child	
	pass
func _process(delta):
	if not repairObject.functional:#enable this area
		$RepairCollisionShape.set_disabled(false)
		$RepairAnimatedSprite2D.visible=true
		$RepairAnimatedSprite2D.play("repairNeeded")
		if mirrorAnimation:#flip according to bool 
			$RepairAnimatedSprite2D.flip_h=true
		$Sparks.emitting = true
		if(sfxRepairNeeded):
			if(!sfxRepairNeeded.playing):
				sfxRepairNeeded = Audio.playSfx(REPAIRNEEDED,true)
		else:
			sfxRepairNeeded=Audio.playSfx(REPAIRNEEDED,true)
	else:
		$RepairCollisionShape.set_disabled(true)#cannot collide with this area
		$RepairAnimatedSprite2D.visible=false
		repairing=false
		$Sparks.emitting = false
		sfxRepairNeeded=null
		
	if player:
		if collided and Input.is_action_pressed("interact") and player.carryingScrap:
				if not repairing:
					$RepairTimer.start()
				if(sfxRepairing):
					if(!sfxRepairing.playing):
						sfxRepairing = Audio.playSfx(REPAIR,true)
				else:
					sfxRepairing=Audio.playSfx(REPAIR,true)
				repairing=true
				

func _on_body_entered(body):
	if body.name=="player":
		Global.player.startRepair=true #disable player dropping scrap when reparing
		collided=true
		if repairing:
			$RepairTimer.set_paused(false)


func _on_body_exited(body):
	if body.name=="player":
		collided=false
		Global.player.startRepair=false 
		if repairing:
			$RepairTimer.set_paused(true)
		


func _on_repair_timer_timeout():
	repairObject.repair()
	player.removeScrap()
	repairing=false
