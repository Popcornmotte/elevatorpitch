extends Control

const FLASHBULB = preload("res://Assets/Audio/sfx/flashbulb.wav")
const ERROR = preload("res://Assets/Audio/sfx/error.wav")
const CLICK = preload("res://Assets/Audio/sfx/click.wav")

var funds = 0
var fuelUnits = 0
var cargoCrates = 0
var cargoslots = 0

var fontSize = 50.0
@export var flashMode = true
@onready var flashLabel = $Monitor/Terminal/FlashLabel 
var index = -1
var flashText = ["SELECT A CONTRACT", "LOAD UP YOUR CARGO SPACE", "CLIMB UP!", "DEFEND!", "DELIVER!", "FALL BACK DOWN!"]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateLabels():
	$Monitor/Terminal/Elevator/Fuel/FuelLabel.text = "Fuel Units ("+str(fuelUnits)+")"
	$Monitor/Terminal/Elevator/ContractCargo/CargoLabel.text = "Contracted Cargo ("+str(cargoCrates)+")"
	$Monitor/Terminal/Elevator/ElevatorHeader.text = "Cargo Capacity: "+str(cargoslots)+"/"+str(Global.inventoryMaxSize)

func flashNext():
	index += 1
	fontSize = 50
	if index >= flashText.size():
		flashMode = false
		flashLabel.hide()
		$Monitor/Terminal/Contracts.show()
		Audio.playSfx(FLASHBULB)
	else:
		flashLabel.text = flashText[index]
		Audio.playSfx(FLASHBULB)

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
	$Monitor/Terminal/Contracts.hide()
	$Monitor/Terminal/Elevator.show()
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
	
	get_tree().change_scene_to_file("res://Scenes/World/test_scenes.tscn")
	
	pass # Replace with function body.


func _on_off_button_pressed():
	get_tree().quit()
	pass # Replace with function body.
