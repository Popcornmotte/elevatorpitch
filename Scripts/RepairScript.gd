extends GenericInteractible

const REPAIR = preload("res://Assets/Audio/sfx/repair.wav")
const REPAIRNEEDED = preload("res://Assets/Audio/sfx/repairNeeded.wav")
enum PARENTOBJECT {Arm, Brake, Net, ElevatorEngine}#settable parent object to select correct animation
@export var parent=PARENTOBJECT.Arm
@export var repairInterior:bool
@export var mirrorAnimation:bool
@export var repairTimeDamaged=2
@export var repairTimeDestroyed=4
@onready var player=Global.player
var collided=false
var sfxRepairing
var sfxRepairNeeded
var repairNeeded=false
var repairing=false

#damaged, can be repaired
func enableOptionalRepair():
	$RepairArea/RepairTimer.set_wait_time(repairTimeDamaged)
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
		PARENTOBJECT.ElevatorEngine:
			$RepairArea/RepairCollisionShapeNet.set_deferred("disabled",false)
			$RepairArea/RepairAnimatedSprite2D.play("damagedEngine")
	$RepairArea/RepairAudioStreamPlayer2D.play()
	$RepairArea/Sparks.visible=true
	repairNeeded=true
	if mirrorAnimation:#flip according to bool 
		$RepairArea/RepairAnimatedSprite2D.flip_h=true
	$RepairArea/Sparks.emitting = true
	#Audio.playSfx(REPAIRNEEDED)
		
#has to be repaired
func enableRepair():
	$RepairArea/RepairAnimatedSprite2D.visible=true
	$RepairArea/RepairTimer.set_wait_time(repairTimeDestroyed)
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
		PARENTOBJECT.ElevatorEngine:
			$RepairArea/RepairCollisionShapeNet.set_deferred("disabled",false)
			$RepairArea/RepairAnimatedSprite2D.play("brokenEngine")
	$RepairArea/RepairAudioStreamPlayer2D.play()
	$RepairArea/Sparks.visible=true
	repairNeeded=true
	if mirrorAnimation:#flip according to bool 
		$RepairArea/RepairAnimatedSprite2D.flip_h=true
	$RepairArea/Sparks.emitting = true
	#Audio.playSfx(REPAIRNEEDED)

	
func repair():
	if $RepairArea/RepairTimer.paused:
		$RepairArea/RepairTimer.set_paused(false)
	elif not repairing:
		$RepairArea/RepairTimer.start()
	
	if(sfxRepairing):
		if(!sfxRepairing.playing):
			sfxRepairing = Audio.playSfx(REPAIR,true)
	else:
		sfxRepairing=Audio.playSfx(REPAIR,true)
	repairing=true
	
	
func pauseRepair():
	$RepairArea/RepairTimer.set_paused(true)

func finishRepair():
	Global.player.removeScrap()
	$RepairArea/RepairTimer.stop()
	print("repair is finished")
	get_parent().repair()#fix 
	
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
	repairNeeded=false
	$RepairArea/RepairAudioStreamPlayer2D.stop()
	$RepairArea/RepairCollisionShape.set_deferred("disabled",true)
	$RepairArea/RepairCollisionShapeNet.set_deferred("disabled",true)
	repairing=false
	finishRepair()


func _on_repair_audio_stream_player_2d_finished():
	$RepairArea/RepairAudioStreamPlayer2D.stop()
