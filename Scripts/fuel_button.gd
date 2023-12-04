extends GenericInteractible


const FUEL=preload("res://Scenes/Objects/Items/fuel.tscn")
const ERROR = preload("res://Assets/Audio/sfx/error.wav")
@onready var funnel=get_node("../DropFunnel")
@onready var dropPosition=funnel.position+Vector2(-20,-30)

func interact():
	if Global.takeFromInventory(Item.TYPE.Fuel):#only dispense fuel if in inventory
		var loadedFuel=FUEL.instantiate()
		loadedFuel.position=dropPosition
		add_child(loadedFuel)
	else:
		Audio.playSfx(ERROR)
		






