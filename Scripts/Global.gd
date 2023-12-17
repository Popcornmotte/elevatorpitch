extends Node

const SAVEFILE_NAME = "elevatorpitch.save"
#Put here all variables that make sense to be globally accessible
var optionsMenu = null
#the elevator will assign itself to this variable
var elevator : Node2D
#the player will assign itself to this as well
var player : Node2D
#current Level Scene. since it is different than root
var level
var height = 0
var aliveEnemies = 0
var inventoryMaxSize = 16
var inventory = Array()
var funds=0

#Options
var masterVolume = 1.0

func _enter_tree():
	loadGame()

func addFunds(newFunds:int):
	funds+=newFunds

func addToInventory(item : Item) -> bool:
	if inventory.size() < inventoryMaxSize:
		inventory.append(item)
		return true
	else:
		return false

func takeFromInventory(type : Item.TYPE):
	for i in inventory.size():
		if inventory[i].type == type:
			return inventory.pop_at(i)
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

#for letting enemies efficiently check for Cargo to steal
func checkForCargo() -> bool:
	return (inventory.any(func(item : Item): return(item.type == Item.TYPE.Cargo)))

func exitGame():
	saveGame()
	get_tree().quit()

func makeSaveDict():
	var saveDict = {
		"funds" : funds,
		"masterVolume" : masterVolume
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
			#funds = data.get("funds")
			masterVolume = loadDataFromDictSafe(dict,masterVolume, "masterVolume")
			#masterVolume = data.get("masterVolume")
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(masterVolume))
		else:
			printerr("Corrupted data!")
	else:
		saveGame();
		printerr("No saved data!")

