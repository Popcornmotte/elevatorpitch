extends Area2D
# i know this is ugly, but trying to modify the elevator scene crashes godot consistently for me
@export var pathToRepair:String
@export var repairInterior:bool
@onready var player=Global.player
var repairObject#=Global.elevator.get_node(pathToRepair)
var collided=false

var repairing=false
func _ready():
	if not repairInterior:#in this case we are repairing something at the elevator, not interior, fix for now, to be removed once the elevator scene is fixed
		repairObject=Global.elevator.get_node(pathToRepair)
	else:
		repairObject=get_parent()#repair something in the interior, just add this script to a child	

func _process(delta):
	if not repairObject.functional:#enable this area
		set_collision_mask_value(5,true)
		$RepairSprite2D.visible=true
	else:
		set_collision_mask_value(5,false)#cannot collide with this area
		$RepairSprite2D.visible=false
		repairing=false
		
	if player:
		if collided and Input.is_action_just_pressed("interact") and player.carryingScrap:
				print("interact in interior: ",player.carryingScrap)# here the .use function of the corresponding object should be called
				$RepairTimer.start()
				repairing=true
				player.removeScrap()
	else:
		print("no player")
		player=get_parent().get_node("../player")# ugly fix for instantiated objects that dont show up otherwise:/
	
func _on_body_entered(body):
	if body.name=="player":
		Global.player.startRepair=true #disable player dropping scrap when reparing
		collided=true
		if repairing:
			$RepairTimer.continue()


func _on_body_exited(body):
	if body.name=="player":
		collided=false
		Global.player.startRepair=false 
		if repairing:
			$RepairTimer.pause()
		


func _on_repair_timer_timeout():
	repairObject.repair()
	repairing=false
