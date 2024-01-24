extends GenericInteractible

var openButton=false#need to interact twice to drop
const OPEN = preload("res://Assets/Audio/sfx/openButton.wav")
const DROPPING = preload("res://Assets/Audio/sfx/dropElevator.wav")
var sfxDropping
var dropping=false
@export var locked = false

func close():
	if openButton:
		$EngineDropText.visible=false
		$EngineDropButtonClosedSprite.visible=true
		$EngineDropButtonOpenSprite2D.visible=false
		$EngineDropButtonPressedSprite2D.visible=false
		Audio.playSfx(OPEN)
		openButton=false
	
func open():
	$EngineDropButtonClosedSprite.visible=false
	$EngineDropButtonOpenSprite2D.visible=true
	$EngineDropButtonPressedSprite2D.visible=false
	Audio.playSfx(OPEN)

func pressed():
	$EngineDropButtonClosedSprite.visible=false
	$EngineDropButtonOpenSprite2D.visible=false
	$EngineDropButtonPressedSprite2D.visible=true

func _ready():
	$EngineDropText.visible=false
	$EngineDropButtonClosedSprite.visible=true
	$EngineDropButtonOpenSprite2D.visible=false
	$EngineDropButtonPressedSprite2D.visible=false

func _process(delta):
	if dropping:
		if(sfxDropping):
			if(!sfxDropping.playing):
				sfxDropping = Audio.playSfx(DROPPING,true)
		else:
			sfxDropping=Audio.playSfx(DROPPING,true)
func use():
	if locked:
		return
	if(openButton):
		pressed()
		if Global.elevator and Global.height>0 :
			Global.elevator.dropElevator()
			dropping=true		
	else:
		open()
		$EngineDropText.visible=true
		openButton=true
		
