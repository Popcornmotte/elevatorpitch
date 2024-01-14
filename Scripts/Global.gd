extends Node

const damageIndicatorPrefab = preload("res://Scenes/Objects/Effects/damage_indicator.tscn")
const SAVEFILE_NAME = "elevatorpitch.save"
#Put here all variables that make sense to be globally accessible
var optionsMenu = null
#the elevator will assign itself to this variable
var elevator : Node2D
#the player will assign itself to this as well
var player : Node2D
#current Level Scene. since it is different than root
var level

var ending = null

var inventoryMatrix : Node2D

enum DMG {Bludgeoning, Piercing, Force, Fire, Lighting }

var height = 0
var heatMeter=0
@export var maxHeat=100
var aliveEnemies = 0
var enemies : Array[Enemy]
var inventoryMaxSize = 16
var inventory = Array()
var funds=0
var newUser = true
var username = ""
var armModule = ArmModuleHandler.MODULE.None
# In order: Arclight, Flamethrower
var modulesUnlocked = [false, false]
# In order: Hangar, Fuel, Enemies, Repair
var tutorialsCompleted = [false, false, false, false]
# AnarchyContracts completed
var anarchyContractsIndex = 1
var maxAnarchyIndex = 7
const REVOLUTIONISTS = ["the Rust Red Dawn", "the Alliance of back-down-to-earth Workers", "the Party of Solidarity Reform", "the Rising Rust Revolution"]
var revolutionists = "" 
var currentContract = Contract.new("Dummy description", 1)

#Options
var masterVolume = 1.0
var musicVolume = 1.0
var effectsVolume = 1.0

func _enter_tree():
	loadGame()

func _ready():
	revolutionists = REVOLUTIONISTS[randi()%REVOLUTIONISTS.size()]

func addFunds(amount:int):
	funds += amount
	return true

func changeHeat(amount):
	if (amount<0 and heatMeter>=0) or (amount>0 and heatMeter<maxHeat):
		heatMeter+=amount
		if heatMeter>=maxHeat:
			Global.elevator.get_node("HullBody/Engine").damage(maxHeat)#blow engine
		
		
func removeFunds(amount:int) -> bool:
	if (funds >= amount):
		funds -= amount
		return true
	else:
		return false

func addToInventory(item : Item) -> bool:
	if inventory.size() < inventoryMaxSize:
		inventory.append(item)
		if(inventoryMatrix != null):
			inventoryMatrix.update()
		return true
	else:
		return false

func takeFromInventory(type : Item.TYPE):
	for i in inventory.size():
		if inventory[i].type == type:
			var item = inventory.pop_at(i)
			if(inventoryMatrix != null):
				inventoryMatrix.update()
			return item
	
	return null

func listInventory():
	print("Listing Inventory:")
	for item in inventory:
		print(str(item))

func countItem(type : Item.TYPE):
	var count = 0
	for item in inventory:
		if item.type == type:
			count += 1
	return count

func inventoryCapacity():
	return inventory.size()

#for letting enemies efficiently check for Cargo to steal
func checkForCargo() -> bool:
	return (inventory.any(func(item : Item): return(item.type == Item.TYPE.Cargo)))

func gameOver():
	funds = 0
	anarchyContractsIndex = 1
	newUser = true
	modulesUnlocked = [false, false]
	level = null
	username = ""
	saveGame()

func winGame(_ending):
	ending = _ending
	get_tree().change_scene_to_file("res://Scenes/World/end_screen.tscn")

func exitGame():
	saveGame()
	get_tree().quit()

func makeSaveDict():
	var saveDict = {
		"funds" : funds,
		"masterVolume" : masterVolume,
		"musicVolume" : musicVolume,
		"effectsVolume" : effectsVolume,
		"tutorialsCompleted" : tutorialsCompleted,
		"modulesUnlocked" : modulesUnlocked,
		"newUser" : newUser,
		"username" : username,
		"anarchyContractsIndex" : anarchyContractsIndex
	}
	return saveDict

func saveGame():
	var file = FileAccess.open_encrypted_with_pass(SAVEFILE_NAME, FileAccess.WRITE, "superorganism")
	file.store_string(JSON.stringify(makeSaveDict()))
	file.close()

#param(dict): the JSON dictionary object returned parsed from saveFile
#param(value): the Global variable that should be set to the data from the savefile
#param(data): the data name to be fetched from the json dict
func loadDataFromDictSafe(dict, value, data : String):
	var temp = dict.get(data)
	if(temp != null):
		return temp
	else:
		printerr("[Global.loadDataFromDictSafe] dict.get("+data+") returned null")
		return value

func loadGame():
	if FileAccess.file_exists(SAVEFILE_NAME):
		var file = FileAccess.open_encrypted_with_pass(SAVEFILE_NAME, FileAccess.READ, "superorganism")
		#file.open(FILE_NAME, File.READ)
		var dict = JSON.parse_string(file.get_as_text())
		#var data = parse_json(file.get_as_text())
		file.close()
		if typeof(dict) == TYPE_DICTIONARY:
			funds=loadDataFromDictSafe(dict, funds, "funds")
			masterVolume = loadDataFromDictSafe(dict,masterVolume, "masterVolume")
			musicVolume = loadDataFromDictSafe(dict,musicVolume, "musicVolume")
			effectsVolume = loadDataFromDictSafe(dict,effectsVolume, "effectsVolume")
			tutorialsCompleted = loadDataFromDictSafe(dict,tutorialsCompleted, "tutorialsCompleted")
			modulesUnlocked = loadDataFromDictSafe(dict,modulesUnlocked,"modulesUnlocked")
			newUser = loadDataFromDictSafe(dict,newUser,"newUser")
			username = loadDataFromDictSafe(dict,username,"username")
			anarchyContractsIndex = loadDataFromDictSafe(dict,anarchyContractsIndex,"anarchyContractsIndex")
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(masterVolume))
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(musicVolume))
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), linear_to_db(effectsVolume))
		else:
			printerr("Corrupted data!")
	else:
		saveGame();
		printerr("No saved data!")

