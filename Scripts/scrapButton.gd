extends GenericInteractible


const SCRAP=preload("res://Scenes/Objects/Items/scrap.tscn")
@onready var funnel=get_node("../DropFunnel")
@onready var dropPosition=funnel.position+Vector2(+20,-30)

func interact():
	var loadedScrap=SCRAP.instantiate()
	loadedScrap.position=dropPosition
	add_child(loadedScrap)
		
