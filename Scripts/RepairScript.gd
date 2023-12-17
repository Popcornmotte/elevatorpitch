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
	$RepairArea/RepairCollisionShape.set_deferred("disabled",false)
	$RepairArea/RepairAnimatedSprite2D.visible=true
	$RepairArea/RepairAudioStreamPlayer2D.play()
	repairNeeded=true
	$RepairArea/RepairAnimatedSprite2D.play("repairNeeded")
	print("enabled")
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
		$RepairArea/RepairTimer.start()
	if(sfxRepairing):
		if(!sfxRepairing.playing):
			sfxRepairing = Audio.playSfx(REPAIR,true)
	else:
		sfxRepairing=Audio.playSfx(REPAIR,true)
	repairing=true

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
	Global.player.removeScrap()
	get_parent().repaired()
	$RepairArea/RepairAudioStreamPlayer2D.stop()
	$RepairArea/RepairCollisionShape.set_deferred("disabled",true)
	repairing=false


func _on_repair_audio_stream_player_2d_finished():
	$RepairArea/RepairAudioStreamPlayer2D.play()
