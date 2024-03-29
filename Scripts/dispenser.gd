extends Node2D

enum DispenseItem{FUEL,SCRAP}
const FUELITEM=preload("res://Scenes/Objects/Items/fuel.tscn")
const SCRAPITEM=preload("res://Scenes/Objects/Items/scrap.tscn")
const ERROR = preload("res://Assets/Audio/sfx/error.wav")
const PLOP=preload("res://Assets/Audio/sfx/plop.wav")
@onready var funnel=get_node("../DropFunnel")
@onready var dropPosition=funnel.position+Vector2(0,50)
@onready var fuelSprite=get_node("FuelSelectionSprite")
@onready var scrapSprite=get_node("ScrapSelectionSprite")
var dispense:DispenseItem
@export var locked = false

# To put things on the floor back in the inventory on level change
var dispensedItems : Array[Node2D]

func _ready():
	dispense=DispenseItem.FUEL
	fuelSprite.set_visible(true)
	scrapSprite.set_visible(false)
	
func switchDispenseType():
	match dispense:
		DispenseItem.FUEL:
			dispense=DispenseItem.SCRAP
			fuelSprite.set_visible(false)
			scrapSprite.set_visible(true)
		DispenseItem.SCRAP:
			dispense=DispenseItem.FUEL
			fuelSprite.set_visible(true)
			scrapSprite.set_visible(false)
	
func dispenseItem():
	if locked:
		Audio.playSfx(ERROR)
		return false
	match dispense:
		DispenseItem.FUEL:
			if Global.takeFromInventory(Item.TYPE.Fuel):#only dispense fuel if in inventory
				var loadedFuel=FUELITEM.instantiate()
				loadedFuel.position=dropPosition+Vector2(randf_range(-5.0,5.0),0)
				get_parent().add_child(loadedFuel)
				dispensedItems.push_back(loadedFuel)
				Audio.playSfx(PLOP)
				return true
			else:
				Audio.playSfx(ERROR)
				return false
		DispenseItem.SCRAP:
			if Global.takeFromInventory(Item.TYPE.Scrap):
				var loadedScrap=SCRAPITEM.instantiate()
				loadedScrap.global_position=dropPosition+Vector2(randf_range(-5.0,5.0),0)
				get_parent().add_child(loadedScrap)
				dispensedItems.push_back(loadedScrap)
				Audio.playSfx(PLOP)
				return true
			else:
				Audio.playSfx(ERROR)
				return false
	return false

func returnToInventory():
	for thing in dispensedItems:
		if thing and weakref(thing).get_ref():
			Global.addToInventory(Item.new(thing.type))
