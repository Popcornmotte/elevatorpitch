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
		
	while(repairing):
		repairing=repairObject.repair(delta)	
	if player:
		if collided and Input.is_action_just_pressed("interact") and not player.carrying:
			print("interact in interior: ",player.carrying)# here the .use function of the corresponding object should be called
			repairing=true
	else:
		print("no player")
		player=get_parent().get_node("../player")# ugly fix for instantiated objects that dont show up otherwise:/
	
	



func _on_body_entered(body):
	if body.name=="player":
		collided=true


func _on_body_exited(body):
	if body.name=="player":
		collided=false
		repairing=false
