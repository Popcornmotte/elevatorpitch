extends Control

const FLASHBULB = preload("res://Assets/Audio/sfx/flashbulb.wav")
const ERROR = preload("res://Assets/Audio/sfx/error.wav")
const CLICK = preload("res://Assets/Audio/sfx/click.wav")
const MOUSECLICK = preload("res://Assets/Audio/sfx/mousClick.wav")
const BEEP0 = preload("res://Assets/Audio/sfx/brrrrBEEP.wav")
const BEEP1 = preload("res://Assets/Audio/sfx/Bweep.wav")
const KATSCHING = preload("res://Assets/Audio/sfx/katsching.wav")
const JINGLE = preload("res://Assets/Audio/sfx/loginJingle0.wav")
const BOOTSOUND = preload("res://Assets/Audio/sfx/startup0.wav")

const RISK0 = preload("res://Assets/Sprites/UI/Contract.png")
const RISK1 = preload("res://Assets/Sprites/UI/Contract1.png")
const RISK2 = preload("res://Assets/Sprites/UI/Contract2.png")
const ANARCHY = preload("res://Assets/Sprites/UI/ContractAnarchy.png")
const ELYSIUM = preload("res://Assets/Sprites/UI/FinalTicket.png")

const CARGOLIST = "res://Contracts/cargo.txt"
var cargoList = []
const SCENARIOLIST = "res://Contracts/scenarios.json"
const RISKLIST = "res://Contracts/risks.json"
const ANARCHYLIST = "res://Contracts/anarchy.json"

const DESTINATIONS = ["Relay Station BETA-42", "Attack Platform Boromir", "Defense Platform Faramir", "Elysium"]

const ArclightPrice = 200
const FlamethrowerPrice = 120
const finalTicketPrice = 200

var fontSize = 50.0
@export var flashMode = true
@onready var flashLabel = $Monitor/Terminal/FlashLabel
@onready var FundsLabel = $Monitor/Terminal/Elevator/ShopLabel
@onready var ArclightCheckbox = $Monitor/Terminal/Elevator/Modules/VBoxContainer/ArcLightBox/ArcLightCheckBox
@onready var FlamethrowerCheckbox = $Monitor/Terminal/Elevator/Modules/VBoxContainer/FlameThrowerBox/FlameThrowerCheckBox

var index = -1
var visChars = 0.0
var booting = true
var flashText = ["SELECT A CONTRACT", "CLIMB UP! DEFEND!", "FALL BACK DOWN!"]
var contracts = []
var selectedContract : int
var contractList
var guaranteeEasyContract = true
# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open(CARGOLIST, FileAccess.READ)
	while(!file.eof_reached()):
		cargoList.append(file.get_line())
	
	if Global.fuelBetweenLevels >= 95.0:
		$Monitor/Terminal/Elevator/HBoxContainer/RefuelButton.set_disabled(true)
	
	if !flashMode:
		$Monitor/Terminal/FlashLabel.hide()
	if(Global.modulesUnlocked[0]):
		$Monitor/Terminal/Elevator/Modules/VBoxContainer/ArcLightBox/ArcLightBuyButton.hide()
		$Monitor/Terminal/Elevator/Modules/VBoxContainer/ArcLightBox/InfoLabel.show()
		ArclightCheckbox.set_disabled(false)
	else:
		$Monitor/Terminal/Elevator/Ammo.hide()
	if(Global.modulesUnlocked[1]):
		$Monitor/Terminal/Elevator/Fuel/InfoLabel.text="Used to fuel elevator engine and flamethrower"
		$Monitor/Terminal/Elevator/Modules/VBoxContainer/FlameThrowerBox/FlameThrowerBuyButton.hide()
		$Monitor/Terminal/Elevator/Modules/VBoxContainer/FlameThrowerBox/InfoLabel.show()
		FlamethrowerCheckbox.set_disabled(false)
	
	if Global.armModule != ArmModuleHandler.MODULE.None:
		match Global.armModule:
			ArmModuleHandler.MODULE.Arclight:
				_on_arc_light_check_box_pressed()
				#$Monitor/Terminal/Elevator/Modules/VBoxContainer/ArcLightBox/ArcLightCheckBox.set_pressed(true)
			ArmModuleHandler.MODULE.Flamethrower:
				_on_flame_thrower_check_box_pressed()
				#$Monitor/Terminal/Elevator/Modules/VBoxContainer/FlameThrowerBox/FlameThrowerCheckBox.set_pressed(true)
			_:
				pass
	
	if (!Global.newUser):
		guaranteeEasyContract = false
		flashMode = false
		booting = false
		$SkipHint.hide()
		$Monitor/Terminal/LogInContainer.hide()
		$Monitor/Header.show()
		$Monitor/Terminal/ContractsView.show()
	else:
		Audio.playSfx(BOOTSOUND)
	
	generateContracts()
	updateLabels()

func generateContracts():
	contractList = $Monitor/Terminal/ContractsView/Contracts
	var scenarioList = JSON.parse_string(FileAccess.open(SCENARIOLIST,FileAccess.READ).get_as_text())
	var riskList = JSON.parse_string(FileAccess.open(RISKLIST,FileAccess.READ).get_as_text())
	
	for i in range(4):
		var riskIndex
		if guaranteeEasyContract:
			riskIndex = "1"
		else:
			riskIndex = str(randi_range(1, riskList.get("0")-1))
		var cargo = cargoList[randi()%cargoList.size()]
		var destinationIndex = randi()%(DESTINATIONS.size()-1)
		var contractDescription = scenarioList.get(str(randi_range(1,scenarioList.get("0")-1)))+riskList.get(riskIndex).get("text")
		contractDescription = contractDescription.replace("[cargo]", cargo+"s")
		contractDescription = contractDescription.replace("[destination]", DESTINATIONS[destinationIndex])
		var contract = Contract.new(contractDescription, riskList.get(riskIndex).get("risk"))
		contract.destination = destinationIndex
		contract.shortDescription = "Deliver "+cargo+" to "+DESTINATIONS[destinationIndex]
		contracts.append(contract)
		contractList.add_item(contract.shortDescription, getIcon(contract.risk))

	if !guaranteeEasyContract:
		var anarchyList = JSON.parse_string(FileAccess.open(ANARCHYLIST,FileAccess.READ).get_as_text()) 
		var anarchyContractDescr = anarchyList.get(str(Global.anarchyContractsIndex))
		anarchyContractDescr = anarchyContractDescr.replace("[destination]", DESTINATIONS[randi()%DESTINATIONS.size()])
		anarchyContractDescr = anarchyContractDescr.replace("[revolutionists]", Global.revolutionists)
		anarchyContractDescr = anarchyContractDescr.replace("[username]",Global.username)
		var anarchyContract = Contract.new(anarchyContractDescr,3)
		anarchyContract.shortDescription = "[REDACTED] #"+str(Global.anarchyContractsIndex)
		anarchyContract.pay = 5
		contracts.append(anarchyContract)
		contractList.add_item(anarchyContract.shortDescription, getIcon(anarchyContract.risk))
	
	var finalDescription = "With this contract you buy a ticket to Elysium Station for the purpose of Retirement among the stars."
	var finalContract = Contract.new(finalDescription,4)
	finalContract.destination = 3
	finalContract.shortDescription = "Elysium Retirement Ticket "+str(finalTicketPrice)+"$$$"
	finalContract.pay = -finalTicketPrice
	contracts.append(finalContract)
	contractList.add_item(finalContract.shortDescription,getIcon(finalContract.risk))

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
			4:
				return ELYSIUM
			_:
				return RISK0

func updateLabels():
	var cargoNum = Global.countItem(Item.TYPE.Cargo)
	if contracts.size() > 0:
		$Monitor/Terminal/Elevator/HBoxContainer2/ProfitLabel.text = "Expected profit: "+str(contracts[selectedContract].pay*cargoNum)+"$"
	$Monitor/Header/HBox/Username.text = "   User: "+Global.username
	FundsLabel.text = "SHOP\nCurrent Account Balance: "+str(Global.funds)+"$"
	$Monitor/Terminal/Elevator/Fuel/AmountLabel.text = "( "+str(Global.countItem(Item.TYPE.Fuel))+" )"
	$Monitor/Terminal/Elevator/ContractCargo/AmountLabel.text = "( "+str(Global.countItem(Item.TYPE.Cargo))+" )"
	$Monitor/Terminal/Elevator/Scrap/AmountLabel.text = "( "+str(Global.countItem(Item.TYPE.Scrap))+" )"
	$Monitor/Terminal/Elevator/ElevatorHeader.text = "Cargo Capacity: "+str(Global.inventoryCapacity())+"/"+str(Global.inventoryMaxSize)
	$Monitor/Terminal/Elevator/Ammo/AmountLabel.text = "( "+str(Global.countItem(Item.TYPE.Ammo))+" )"

func flashNext():
	index += 1
	fontSize = 50
	if index >= flashText.size():
		flashMode = false
		flashLabel.hide()
		#$Monitor/Header.show()
		#$Monitor/Terminal/ContractsView.show()
		$Monitor/Terminal/LogInContainer.show()
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
	if contract.risk != 4:
		$Monitor/Terminal/ContractInspector/Buttons/AcceptButton.text = " [ ACCEPT ] "
		$Monitor/Terminal/ContractInspector/Pay.text = str(contract.pay)+"$ for each Crate"
	else:
		$Monitor/Terminal/ContractInspector/Buttons/AcceptButton.text = " [ BUY TICKET ] "
		$Monitor/Terminal/ContractInspector/Pay.text = str(contract.pay)+"$ fee for ascension ticket!"
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

func beep():
	if(randi()%2):
		Audio.playSfx(BEEP0)
	else:
		Audio.playSfx(BEEP1)

func _input(event):
	if Input.is_action_just_pressed("Grab"):
		Audio.playSfx(MOUSECLICK)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Debug"):
		Global.addFunds(200)
		updateLabels()
	if flashMode:
		if(fontSize > 20):
			fontSize -= delta*25
			flashLabel.add_theme_font_size_override("font_size",fontSize)
		if Input.is_action_just_pressed("Grab"):
			flashNext()
	if Global.newUser && booting:
		if Input.is_action_just_pressed("Fling"):
			$Monitor/Terminal/LogInContainer/LoginText.visible_characters = -1
		if $Monitor/Terminal/LogInContainer/LoginText.visible_ratio < 1.0:
			visChars += 15*delta
			$Monitor/Terminal/LogInContainer/LoginText.visible_characters = int(visChars)
		else:
			booting = false
			$SkipHint.hide()
			$Monitor/Terminal/LogInContainer/LineEdit.show()
			$Monitor/Terminal/LogInContainer/LineEdit.grab_focus()
	pass

func incrementResource(itemType : Item.TYPE):
	if(Global.addToInventory(Item.new(itemType))):
		Audio.playSfx(CLICK)
		if itemType == Item.TYPE.Cargo:
			$AnimationPlayer.play("profit")
		updateLabels()
	else:
		Audio.playSfx(ERROR)

func decrementResource(itemType : Item.TYPE):
	if itemType == Item.TYPE.Cargo && Global.countItem(Item.TYPE.Cargo) == 1:
		Audio.playSfx(ERROR)
		return
	if(Global.takeFromInventory(itemType) != null):
		if itemType == Item.TYPE.Cargo:
			$AnimationPlayer.play("unprofit")
		updateLabels()
		Audio.playSfx(CLICK)
	else:
		Audio.playSfx(ERROR)


func _on_contract_item_list_item_clicked(index, at_position, mouse_button_index):
	#Just for low target but later this should deliver contract ID
	if mouse_button_index <= 2:
		beep()
		#print("mouse button index: "+str(mouse_button_index))
		$Monitor/Terminal/ContractsView.hide()
		showContractInspector(index)
		#$Monitor/Terminal/Elevator.show()
	pass # Replace with function body.


func _on_decrement_fuel_button_pressed():
	decrementResource(Item.TYPE.Fuel)
	pass # Replace with function body.


func _on_increment_fuel_button_pressed():
	incrementResource(Item.TYPE.Fuel)
	pass # Replace with function body.


func _on_decrement_cargo_button_pressed():
	decrementResource(Item.TYPE.Cargo)
	pass # Replace with function body.


func _on_increment_cargo_button_pressed():
	incrementResource(Item.TYPE.Cargo)
	pass # Replace with function body.


func _on_start_button_pressed():
	Global.saveGame()
	Audio.playSfx(CLICK)
	beep()
	if(ArclightCheckbox.button_pressed):
		Global.armModule=ArmModuleHandler.MODULE.Arclight
	elif(FlamethrowerCheckbox.button_pressed):
		Global.armModule=ArmModuleHandler.MODULE.Flamethrower
	else:
		Global.armModule=ArmModuleHandler.MODULE.None
	Audio.stopMusic()
	get_tree().change_scene_to_file("res://Scenes/World/hangar.tscn")
	
	pass # Replace with function body.


func _on_off_button_pressed():
	Global.saveGame()
	Audio.stopMusic()
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
	pass # Replace with function body.


func _on_back_button_pressed():
	beep()
	#return from contract inspector to contracts overview
	$Monitor/Terminal/ContractInspector.hide()
	$Monitor/Terminal/ContractsView.show()
	pass # Replace with function body.


func _on_accept_button_pressed():
	var contract = contracts[selectedContract]
	if Global.countItem(Item.TYPE.Cargo) == 0:
		incrementResource(Item.TYPE.Cargo)
		#Global.addToInventory(Item.new(Item.TYPE.Cargo))
	
	if ((contract.risk == 4) or (contract.risk == 3 and Global.anarchyContractsIndex == Global.maxAnarchyIndex)):
		if(Global.removeFunds(finalTicketPrice)):
			Audio.playSfx(KATSCHING)
			var ending
			if contract.risk == 4:
				ending = 0
			elif contract.risk == 3:
				ending = 1
			Global.winGame(ending)
			
		else:
			Audio.playSfx(ERROR)
	else:
		beep()
		Global.currentContract = contracts[selectedContract]
		$Monitor/Terminal/ContractInspector.hide()
		$Monitor/Terminal/Elevator.show()
	pass # Replace with function body.


func _on_decrement_scrap_button_pressed():
	decrementResource(Item.TYPE.Scrap)
	pass # Replace with function body.


func _on_increment_scrap_button_pressed():
	incrementResource(Item.TYPE.Scrap)
	pass # Replace with function body.


func _on_arc_light_buy_button_pressed():
	if(Global.removeFunds(ArclightPrice)):
		Global.modulesUnlocked[0] = true
		$Monitor/Terminal/Elevator/Ammo.show()
		ArclightCheckbox.set_disabled(false)
		$Monitor/Terminal/Elevator/Modules/VBoxContainer/ArcLightBox/ArcLightBuyButton.hide()
		$Monitor/Terminal/Elevator/Modules/VBoxContainer/ArcLightBox/InfoLabel.show()
		Audio.playSfx(KATSCHING)
		_on_arc_light_check_box_pressed()
	else:
		Audio.playSfx(ERROR)
	pass # Replace with function body.


func _on_flame_thrower_buy_button_pressed():
	if(Global.removeFunds(FlamethrowerPrice)):
		Global.modulesUnlocked[1] = true
		FlamethrowerCheckbox.set_disabled(false)
		$Monitor/Terminal/Elevator/Fuel/InfoLabel.text="Used to fuel elevator engine and flamethrower"
		$Monitor/Terminal/Elevator/Modules/VBoxContainer/FlameThrowerBox/FlameThrowerBuyButton.hide()
		$Monitor/Terminal/Elevator/Modules/VBoxContainer/FlameThrowerBox/InfoLabel.show()
		Audio.playSfx(KATSCHING)
		_on_flame_thrower_check_box_pressed()
	else:
		Audio.playSfx(ERROR)
	pass # Replace with function body.


func _on_arc_light_check_box_pressed():
	if(FlamethrowerCheckbox.button_pressed):
		FlamethrowerCheckbox.button_pressed=false
	pass # Replace with function body.


func _on_flame_thrower_check_box_pressed():
	if(ArclightCheckbox.button_pressed):
		ArclightCheckbox.button_pressed=false
	pass # Replace with function body.


func _on_decrement_ammo_button_pressed():
	decrementResource(Item.TYPE.Ammo)
	pass # Replace with function body.


func _on_increment_ammo_button_pressed():
	incrementResource(Item.TYPE.Ammo)
	pass # Replace with function body.


func _on_line_edit_text_submitted(new_text):
	Audio.playSfx(BEEP0)
	Audio.playSfx(JINGLE)
	Global.newUser = false
	Global.username = new_text
	updateLabels()
	$Monitor/Header.show()
	$Monitor/Terminal/ContractsView.show()
	$Monitor/Terminal/LogInContainer.hide()
	pass # Replace with function body.


func _on_refuel_button_pressed():
	if(Global.removeFunds(50)):
		Audio.playSfx(KATSCHING)
		Global.fuelBetweenLevels = 100.0
		updateLabels()
		$Monitor/Terminal/Elevator/HBoxContainer/RefuelButton.set_disabled(true)
	else:
		Audio.playSfx(ERROR)
	pass # Replace with function body.
