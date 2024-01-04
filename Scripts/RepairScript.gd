extends GenericInteractible

const REPAIR = preload("res://Assets/Audio/sfx/repair.wav")
const REPAIRNEEDED = preload("res://Assets/Audio/sfx/repairNeeded.wav")
enum PARENTOBJECT {Arm, Brake, Net, ElevatorEngine}#settable parent object to select correct animation
@export var parent=PARENTOBJECT.Arm
@export var repairInterior:bool
@export var mirrorAnimation:bool
@onready var player=Global.player
var collided=false
var sfxRepairing
var sfxRepairNeeded
var repairNeeded=false
var repairing=false

#damaged, can be repaired
func enableOptionalRepair():
	$RepairArea/RepairAnimatedSprite2D.visible=true
	match parent:
		PARENTOBJECT.Arm: 
			$RepairArea/RepairCollisionShape.set_deferred("disabled",false)
			$RepairArea/RepairAnimatedSprite2D.play("damagedArm")
		PARENTOBJECT.Brake:
			$RepairArea/RepairCollisionShape.set_deferred("disabled",false)
			$RepairArea/RepairAnimatedSprite2D.play("damagedBrake")
		PARENTOBJECT.Net:
			$RepairArea/RepairCollisionShapeNet.set_deferred("disabled",false)
			$RepairArea/RepairAnimatedSprite2D.play("damagedNet")
	$RepairArea/RepairAudioStreamPlayer2D.play()
	repairNeeded=true
	if mirrorAnimation:#flip according to bool 
		$RepairArea/RepairAnimatedSprite2D.flip_h=true
	$RepairArea/Sparks.emitting = true
	if(sfxRepairNeeded):
		if(!sfxRepairNeeded.playing):
			sfxRepairNeeded = Audio.playSfx(REPAIRNEEDED,true)
	else:
		sfxRepairNeeded=Audio.playSfx(REPAIRNEEDED,true)
		
#has to be repaired
func enableRepair():
	$RepairArea/RepairAnimatedSprite2D.visible=true
	match parent:
		PARENTOBJECT.Arm:
			$RepairArea/RepairCollisionShape.set_deferred("disabled",false)
			$RepairArea/RepairAnimatedSprite2D.play("brokenArm")
		PARENTOBJECT.Brake:
			$RepairArea/RepairCollisionShape.set_deferred("disabled",false)
			$RepairArea/RepairAnimatedSprite2D.play("brokenBrake")
		PARENTOBJECT.Net:
			$RepairArea/RepairCollisionShapeNet.set_deferred("disabled",false)
			$RepairArea/RepairAnimatedSprite2D.play("brokenNet")
	$RepairArea/RepairAudioStreamPlayer2D.play()
	repairNeeded=true
	if mirrorAnimation:#flip according to bool 
		$RepairArea/RepairAnimatedSprite2D.flip_h=true
	$RepairArea/Sparks.emitting = true
	if(sfxRepairNeeded):
		if(!sfxRepairNeeded.playing):
			sfxRepairNeeded = Audio.playSfx(REPAIRNEEDED,true)
	else:
		sfxRepairNeeded=Audio.playSfx(REPAIRNEEDED,true)

	
func repair():
	if not repairing:
		print("start timer")
		$RepairArea/RepairTimer.start()
	if(sfxRepairing):
		if(!sfxRepairing.playing):
			sfxRepairing = Audio.playSfx(REPAIR,true)
	else:
		sfxRepairing=Audio.playSfx(REPAIR,true)
	repairing=true
	var timeToWait=$RepairArea/RepairTimer.get_wait_time()
	var repairAmount=timeToWait-$RepairArea/RepairTimer.get_time_left()
	get_parent().repair(repairAmount)
	

func finishRepair():
	Global.player.removeScrap()
	$RepairArea/RepairTimer.stop()
	
func _on_body_entered(body):
	if body.name=="player":
		Global.player.startRepair=true #disable player dropping scrap when reparing
		if repairing:
			$RepairArea/RepairTimer.set_paused(false)


func _on_body_exited(body):
	if body.name=="player":
		Global.player.startRepair=false 
		if repairing:
			finishRepair()
		


func _on_repair_timer_timeout():
	repairNeeded=false
	$RepairArea/RepairAudioStreamPlayer2D.stop()
	$RepairArea/RepairCollisionShape.set_deferred("disabled",true)
	$RepairArea/RepairCollisionShapeNet.set_deferred("disabled",true)
	repairing=false
	finishRepair()


func _on_repair_audio_stream_player_2d_finished():
	$RepairArea/RepairAudioStreamPlayer2D.play()
