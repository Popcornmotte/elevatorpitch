extends Area2D

const REPAIR = preload("res://Assets/Audio/sfx/repair.wav")
# i know this is ugly, but trying to modify the elevator scene crashes godot consistently for me
@export var pathToRepair:Node2D
@export var repairInterior:bool
@onready var player=Global.player
var repairObject#=Global.elevator.get_node(pathToRepair)
var collided=false
var sfx

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
		$RepairSprite2D.visible=true
	else:
		$RepairCollisionShape.set_disabled(true)#cannot collide with this area
		$RepairSprite2D.visible=false
		repairing=false
		
	if player:
		if collided and Input.is_action_pressed("interact") and player.carryingScrap:
				#print("interact in interior: ",player.carryingScrap)# here the .use function of the corresponding object should be called
				$RepairTimer.start()
				if(sfx):
					if(!sfx.playing):
						sfx = Audio.playSfx(REPAIR,true)
				else:
					sfx=Audio.playSfx(REPAIR,true)
				repairing=true
				

func _on_body_entered(body):
	if body.name=="player":
		print("Reparo: player entered")
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
	print("Hellop tiomewtsljsdlf")
	repairObject.repair()
	player.removeScrap()
	repairing=false
