extends Node2D

enum DispenseItem{FUEL,SCRAP}
const FUELITEM=preload("res://Scenes/Objects/Items/fuel.tscn")
const SCRAPITEM=preload("res://Scenes/Objects/Items/scrap.tscn")
const ERROR = preload("res://Assets/Audio/sfx/error.wav")
@onready var funnel=get_node("../DropFunnel")
@onready var dropPosition=funnel.position+Vector2(-30,-30)
@onready var fuelSprite=get_node("FuelSelectionSprite")
@onready var scrapSprite=get_node("ScrapSelectionSprite")
var dispense:DispenseItem

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
	match dispense:
		DispenseItem.FUEL:
			if Global.takeFromInventory(Item.TYPE.Fuel):#only dispense fuel if in inventory
				print("fuel dispensed")
				var loadedFuel=FUELITEM.instantiate()
				loadedFuel.position=dropPosition
				add_child(loadedFuel)
				return
			else:
				Audio.playSfx(ERROR)
				return
		DispenseItem.SCRAP:
			print("scrap dispensed")
			var loadedScrap=SCRAPITEM.instantiate()
			loadedScrap.position=dropPosition
			add_child(loadedScrap)
			return
