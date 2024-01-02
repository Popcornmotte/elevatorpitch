extends GenericInteractible

var openButton=false#need to interact twice to drop

func closed():
	$EngineDropButtonClosedSprite.visible=true
	$EngineDropButtonOpenSprite2D.visible=false
	$EngineDropButtonPressedSprite2D.visible=false
	
func open():
	$EngineDropButtonClosedSprite.visible=false
	$EngineDropButtonOpenSprite2D.visible=true
	$EngineDropButtonPressedSprite2D.visible=false

func pressed():
	$EngineDropButtonClosedSprite.visible=false
	$EngineDropButtonOpenSprite2D.visible=false
	$EngineDropButtonPressedSprite2D.visible=true

func _ready():
	closed()
	
func use():
	if(openButton):
		pressed()
		print("dropping")
	else:
		open()
		openButton=true
		
