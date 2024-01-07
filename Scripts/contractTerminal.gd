extends Control

const FLASHBULB = preload("res://Assets/Audio/sfx/flashbulb.wav")
const ERROR = preload("res://Assets/Audio/sfx/error.wav")
const CLICK = preload("res://Assets/Audio/sfx/click.wav")

const RISK0 = preload("res://Assets/Sprites/UI/Contract.png")
const RISK1 = preload("res://Assets/Sprites/UI/Contract1.png")
const RISK2 = preload("res://Assets/Sprites/UI/Contract2.png")
const ANARCHY = preload("res://Assets/Sprites/UI/ContractAnarchy.png")

const CARGOLIST = "res://Contracts/cargo.txt"
var cargoList = []
const SCENARIOLIST = "res://Contracts/scenarios.json"
const RISKLIST = "res://Contracts/risks.json"

const DESTINATIONS = ["Relay Station BETA-42", "Attack Platform Boromir", "Defense Platform Faramir"]

var fuelUnits = 0
var cargoCrates = 0
var cargoslots = 0

var fontSize = 50.0
@export var flashMode = true
@onready var flashLabel = $Monitor/Terminal/FlashLabel
@onready var FundsLabel = $Monitor/Header/HBox/Funds
var index = -1
var flashText = ["SELECT A CONTRACT", "CLIMB UP! DEFEND!", "FALL BACK DOWN!"]
var contracts = []
var selectedContract : int
var contractList
# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open(CARGOLIST, FileAccess.READ)
	while(!file.eof_reached()):
		cargoList.append(file.get_line())
	updateLabels()
	generateContracts()

func generateContracts():
	contractList = $Monitor/Terminal/ContractsView/Contracts
	var scenarioList = JSON.parse_string(FileAccess.open(SCENARIOLIST,FileAccess.READ).get_as_text())
	var riskList = JSON.parse_string(FileAccess.open(RISKLIST,FileAccess.READ).get_as_text())
	for i in range(5):
		var riskIndex = str(randi_range(1, riskList.get("0")-1))
		var cargo = cargoList[randi()%cargoList.size()]
		var destinationIndex = randi()%DESTINATIONS.size()
		var contractDescription = scenarioList.get(str(randi_range(1,scenarioList.get("0")-1)))+riskList.get(riskIndex).get("text")
		contractDescription = contractDescription.replace("[cargo]", cargo+"s")
		contractDescription = contractDescription.replace("[destination]", DESTINATIONS[destinationIndex])
		var contract = Contract.new(contractDescription, riskList.get(riskIndex).get("risk"))
		contract.destination = destinationIndex
		contract.shortDescription = "Deliver "+cargo+" to "+DESTINATIONS[destinationIndex]
		contracts.append(contract)
		contractList.add_item(contract.shortDescription, getIcon(contract.risk))

func getIcon(risk):
		match risk:
			0:
				return RISK0
			1:
				return RISK1
			2:
				return RISK2
			3:
				return ANARCHY
			_:
				return RISK0

func updateLabels():
	FundsLabel.text = "Current Account Balance: "+str(Global.funds)+"$"
	$Monitor/Terminal/Elevator/Fuel/FuelLabel.text = "Fuel Units ("+str(fuelUnits)+")"
	$Monitor/Terminal/Elevator/ContractCargo/CargoLabel.text = "Contracted Cargo ("+str(cargoCrates)+")"
	$Monitor/Terminal/Elevator/ElevatorHeader.text = "Cargo Capacity: "+str(cargoslots)+"/"+str(Global.inventoryMaxSize)


func flashNext():
	index += 1
	fontSize = 50
	if index >= flashText.size():
		flashMode = false
		flashLabel.hide()
		$Monitor/Header.show()
		$Monitor/Terminal/ContractsView.show()
		Audio.playSfx(FLASHBULB)
	else:
		flashLabel.text = flashText[index]
		Audio.playSfx(FLASHBULB)

func showContractInspector(contractID : int):
	selectedContract = contractID
	var contract = contracts[contractID]
	$Monitor/Terminal/ContractInspector/Info/ShortDescription.text = contract.shortDescription
	$Monitor/Terminal/ContractInspector/Info/Icon.set_texture(getIcon(contract.risk))
	$Monitor/Terminal/ContractInspector/Description.text = contract.description
	
	$Monitor/Terminal/ContractInspector/Pay.text = str(contract.pay)+"$ for each Crate"
	var riskText
	match contract.risk:
		0:
			riskText = "Risk: Low"
		1:
			riskText = "Risk: Medium"
		2:
			riskText = "Risk: High"
		_:
			riskText = "Risk: Unkown"
	$Monitor/Terminal/ContractInspector/Info/Risk.text = riskText
	$Monitor/Terminal/ContractInspector.show()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flashMode:
		if(fontSize > 20):
			fontSize -= delta*25
			flashLabel.add_theme_font_size_override("font_size",fontSize)
		if Input.is_action_just_pressed("Grab"):
			flashNext()
	pass


func _on_contract_item_list_item_clicked(index, at_position, mouse_button_index):
	#Just for low target but later this should deliver contract ID
	$Monitor/Terminal/ContractsView.hide()
	showContractInspector(index)
	#$Monitor/Terminal/Elevator.show()
	pass # Replace with function body.


func _on_decrement_fuel_button_pressed():
	if(fuelUnits > 0):
		fuelUnits -= 1
		cargoslots -= 1
		updateLabels()
		Audio.playSfx(CLICK)
	else:
		Audio.playSfx(ERROR)
	pass # Replace with function body.


func _on_increment_fuel_button_pressed():
	if(cargoslots < Global.inventoryMaxSize):
		fuelUnits += 1
		cargoslots += 1
		updateLabels()
		Audio.playSfx(CLICK)
	else:
		Audio.playSfx(ERROR)
	pass # Replace with function body.


func _on_decrement_cargo_button_pressed():
	if(cargoCrates > 0):
		cargoCrates -= 1
		cargoslots -= 1
		updateLabels()
		Audio.playSfx(CLICK)
	else:
		Audio.playSfx(ERROR)
	pass # Replace with function body.


func _on_increment_cargo_button_pressed():
	if(cargoslots < Global.inventoryMaxSize):
		cargoCrates += 1
		cargoslots += 1
		updateLabels()
		Audio.playSfx(CLICK)
	else:
		Audio.playSfx(ERROR)
	pass # Replace with function body.


func _on_start_button_pressed():
	Audio.playSfx(CLICK)
	for i in range(cargoCrates):
		Global.addToInventory(Item.new(Item.TYPE.Cargo))
	for i in range(fuelUnits):
		Global.addToInventory(Item.new(Item.TYPE.Fuel))
	
	get_tree().change_scene_to_file("res://Scenes/World/hangar.tscn")
	
	pass # Replace with function body.


func _on_off_button_pressed():
	Global.exitGame()
	pass # Replace with function body.


func _on_back_button_pressed():
	#return from contract inspector to contracts overview
	$Monitor/Terminal/ContractInspector.hide()
	$Monitor/Terminal/ContractsView.show()
	pass # Replace with function body.


func _on_accept_button_pressed():
	Global.currentContract = contracts[selectedContract]
	$Monitor/Terminal/ContractInspector.hide()
	$Monitor/Terminal/Elevator.show()
	pass # Replace with function body.
