extends CharacterBody2D
const FUEL=preload("res://Scenes/Objects/Items/fuel.tscn")
const SCRAP=preload("res://Scenes/Objects/Items/scrap.tscn")

const WALKINGSOUND=preload("res://Assets/Audio/sfx/walking.wav")
const CLIMBINGSOUND=preload("res://Assets/Audio/sfx/climbing.wav")
const PICKUPSOUND=preload("res://Assets/Audio/sfx/pickUp.wav")
const DROPSOUND=preload("res://Assets/Audio/sfx/dropObject.wav")

@export var speed = 100.0
@export var climbSpeed=50.0
@export var jumpVelocity = -150.0
@export var maxFallingSpeed=500.0 #this should not be relevant, but cap at which body does not accelerate any more when falling
@export var climbing=false #variable set when interacting with ladder to indicate climb
@export var pushForce=80.0 #relevant when colliding with other rigidbodies
@export var startZoomedIn = true
@onready var sprite = get_node("PlayerSprite")
@onready var fuelSprite=get_node("FuelSprite")
@onready var scrapSprite=get_node("ScrapSprite")
@onready var zoomAnimation = $PlayerCam/ZoomAnimation

var carryables : Array[Node2D]
var carrying=false
var carriedFuel = 0.0
var canTakeDamage=false
var justPickedUp = false
var canDrop=true #block dropping immediately when interacting with refuelStation
var carryPos=Vector2(8,1)
@export var controlPlayer=true # the player is controllable when the arms are not, get this information from the elevator if it exists
var carryType= Item.TYPE.Fuel
var startRepair=false#block dropping of scrap when in vicinity of repair station
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var movementParent : Node2D
var lastParentPos : Vector2
var cameraMargins = 0.0
var cameraZoom = 1.0
var sfx
var interactionObject:Node2D #object that the player is interacting with
var dispenserObject:Node2D #object that the player is interacting with to dispense fuel or scrap
var brakeObject:Node2D
var refuelEngineObject:Node2D
var jetpack = false
var lerpFactor = 0.3
@export var health=5

func _ready():
	Global.player = self
	cameraMargins = $PlayerCam.get_drag_margin(0)
	zoomIn(startZoomedIn)
	$Healthbar.hide()

func playPlayerSound(clip : AudioStream):
	if(sfx):
		if(!sfx.playing):
			sfx = Audio.playSfx(clip,false)
	else:
		sfx=Audio.playSfx(clip,true)
		
func flipAnimation(right):
	if right:
		sprite.flip_h=false
		fuelSprite.position=carryPos
		scrapSprite.position=carryPos
	else:
		sprite.flip_h=true
		fuelSprite.position=carryPos*Vector2(-1,1)
		scrapSprite.position=carryPos*Vector2(-1,1)

func takeDamage(damage:int,type):
	#type is currently ignored in elevator
	if canTakeDamage:
		health-=damage
		$Healthbar/TextureProgressBar.value=health
		if health<=0:
			Global.elevator.dropping=true
			Global.elevator.dropElevator(true)#activate gameover scene
		pass
	
func zoomIn(state : bool):
	if state:
		#zoomAnimation.play("zoom_in")
		cameraZoom = 3
		for side in range(0,4):
			$PlayerCam.set_drag_margin(side, cameraMargins)
	else:
		#zoomAnimation.play("zoom_out")
		cameraZoom = 1
		for side in range(0,4):
			$PlayerCam.set_drag_margin(side, 0)
	pass

func updateZoom(delta):
	var newZoom = lerpf($PlayerCam.get_zoom().x, cameraZoom, 4*delta)
	$PlayerCam.set_zoom(Vector2(newZoom, newZoom))
	
# Function that needs to be called after move and slide to provide collision with rigidbodies
func collideWithRigidbodies():
	for i in get_slide_collision_count():
		var c=get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal()*pushForce)

func addCarryable(thing):
	carryables.push_back(thing)
	var outline = thing.find_child("Outline")
	if outline != null:
		outline.visible = true
	
func removeCarryable(thing):
	carryables.erase(thing)
	var outline = thing.find_child("Outline")
	if outline != null:
		outline.visible = false

func pickUpObject():
	if carrying:#in case the player is already holding something, nothing else should be picked up
		return false
	var thing = carryables.pop_back()
	var typeArg = thing.getType()
	if typeArg==Item.TYPE.Fuel:
		fuelSprite.visible=true
		carryType=Item.TYPE.Fuel
		carriedFuel = thing.fuel
		if refuelEngineObject:
			canDrop=false#dont drop when refuelling
			refuelEngineObject.prepareRefuel()
	elif typeArg==Item.TYPE.Scrap:
		scrapSprite.visible=true
		carryType=Item.TYPE.Scrap
	carrying=true
	justPickedUp = true
	thing.queue_free()
	Audio.playSfx(PICKUPSOUND)
	return true

func dropObject():
	if canDrop:
		if carrying:
			Audio.playSfx(DROPSOUND)
		if carryType==Item.TYPE.Fuel:
			fuelSprite.visible=false
			carrying=false
			var loadedFuel=FUEL.instantiate()
			get_parent().add_child(loadedFuel)
			loadedFuel.global_position=fuelSprite.get_global_position()
			carriedFuel = 0.0
		if carryType==Item.TYPE.Scrap and not startRepair:# do not drop scrap when interacting with repair
			scrapSprite.visible=false
			carrying=false
			var loadedScrap=SCRAP.instantiate()
			get_parent().add_child(loadedScrap)
			loadedScrap.global_position=scrapSprite.get_global_position()

func toggleJetpack(state : bool):
	jetpack = state
	if state:
		canTakeDamage=true
		$Healthbar.show()
		$Gun.setEnabled(true)
		$PlayerCam.setMousePeek(true)
		z_index=10
		lerpFactor = 0.02
		gravity = 0
		$jetpackParticles.emitting = true
		$jetpackSound.play()
	else:
		canTakeDamage=false
		$Healthbar.hide()
		$Gun.setEnabled(false)
		$PlayerCam.setMousePeek(false)
		lerpFactor = 0.3
		z_index=4
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
		$jetpackParticles.emitting = false
		$jetpackSound.stop()

func move(direction, vertical = 0.0):
	if velocity.x >=0:
		flipAnimation(true)
	else:
		flipAnimation(false)
		
	if direction or vertical:
		if is_on_floor():
			sprite.play("walk")
			playPlayerSound(WALKINGSOUND)
		else:
			sprite.play("jetpack")
		#allow the player to also move mid jump
		velocity.x = lerpf(velocity.x, direction*speed, lerpFactor)
		if jetpack:
			velocity.y = lerpf(velocity.y,vertical * speed, lerpFactor)
		
	else:
		if is_on_floor():
			sprite.play("idle")
		velocity.x = lerpf(velocity.x,0.0,lerpFactor)
		if jetpack:
			sprite.play("jetpackIdle")
			velocity.y = lerpf(velocity.y,0.0,lerpFactor)

func setMovementParent(newParent : Node2D):
	movementParent = newParent
	lastParentPos = movementParent.global_position

func moveWithParent(delta):
	if movementParent == null:
		return
	velocity.y = ((movementParent.global_position - lastParentPos) / delta).y * 0.9
	lastParentPos = movementParent.global_position

func removeScrap():#called when carrying scrap and repairing something
	scrapSprite.visible=false
	carrying=false
	
func removeFuel(wasted : float):#called when carrying fuel and refuelled 
	fuelSprite.visible=false
	carrying=false
	carriedFuel = 0.0
	if wasted > 0:
		var droppedCanister = FUEL.instantiate()
		add_sibling(droppedCanister)
		droppedCanister.global_position = global_position - Vector2(0,8)
		droppedCanister.linear_velocity = Vector2(0,-160).rotated(randf_range(-PI/2,PI/2))
		droppedCanister.angular_velocity = randf_range(-50,50)
		droppedCanister.fuel = wasted * 0.75

func fall(direction,delta):
	velocity.y += gravity * delta
	if jetpack:
		sprite.play("idle")
	else:
		sprite.play("jump")

	#cap falling speed
	if velocity.y>maxFallingSpeed:
		velocity.y=maxFallingSpeed

func climb(direction):
	velocity.y=0
	sprite.play("climb")
	playPlayerSound(CLIMBINGSOUND)
	if Input.is_action_pressed("up"):
		velocity.y=-speed
	elif Input.is_action_pressed("down"):
		velocity.y=speed
	if carrying:#disable sprite when climbing
		if carryType==Item.TYPE.Fuel:
			fuelSprite.visible=false
		if carryType==Item.TYPE.Scrap:
			scrapSprite.visible=false


func _process(delta):
	updateZoom(delta)
	moveWithParent(delta)
	if controlPlayer:
		if Input.is_action_just_pressed("Grab"):
			$Gun.shoot()
		if Input.is_action_just_pressed("Debug"):
			toggleJetpack(!jetpack)
		
		if justPickedUp and Input.is_action_just_released("interact"):
			justPickedUp = false
		
		if refuelEngineObject and Input.is_action_just_released("interact"):
			refuelEngineObject.stopRefuel()
		
		if Input.is_action_just_pressed("interact"):
			if carrying:
				dropObject()
			elif carryables.size() > 0:
				pickUpObject()
			#check if player is interacting with something
			if !justPickedUp and interactionObject:
				interactionObject.use()
			if !justPickedUp and refuelEngineObject and carrying and carryType==Item.TYPE.Fuel:
				refuelEngineObject.startRefuel()
	
		if carrying and  carryType==Item.TYPE.Scrap and Input.is_action_pressed("repair") and interactionObject:
			interactionObject.repair()
		
		if carrying and  carryType==Item.TYPE.Scrap and Input.is_action_just_released("repair") and interactionObject:
			interactionObject.pauseRepair()
			
		if dispenserObject and Input.is_action_just_pressed("down"):
			dispenserObject.switchDispenseType()
		
		if !justPickedUp and dispenserObject and Input.is_action_just_pressed("interact"):
			dispenserObject.dispenseItem()
		
		if brakeObject and Input.is_action_just_pressed("up"):
			brakeObject.switchUp()
		if brakeObject and Input.is_action_just_pressed("down"):
			brakeObject.switchDown()
			
func _physics_process(delta):
	if Global.elevator:
		controlPlayer=!Global.elevator.controlArms#control player when not controlling arms
	if controlPlayer:	
		#direction is used to flip animations accordingly
		var direction = Input.get_axis("left", "right")
		var vertical = 0
		if jetpack:
			vertical = Input.get_axis("up","down")
		if not climbing and not is_on_floor():
			fall(direction,delta)
			set_collision_mask_value(5,true)
		elif climbing:
			climb(direction)
			set_collision_mask_value(5,false)#allows player to pass through floor when climbing
		if not climbing:
			set_collision_mask_value(5,true)
			if carrying:#reenable sprite when not climbing
				if carryType==Item.TYPE.Fuel:
					fuelSprite.visible=true
				if carryType==Item.TYPE.Scrap:
					scrapSprite.visible=true
		move(direction,vertical)
		move_and_slide()
		collideWithRigidbodies()
		

func _on_interaction_area_area_entered(area):
	if area.owner and area.owner.name=="Dispenser":
		if Global.level!=null:
			Global.optionsMenu.switch(Global.TUTORIAL_INDICES.DISPENSER)
		dispenserObject=area.owner #special case, as pressing s will change dispense type
	if area.owner and area.owner.name=="Brake":
		brakeObject=area.owner
	if area.owner and area.owner.name=="RefuelEngine":
		refuelEngineObject=area.owner#special case, interaction only when holding fuel and pressing e
		if carrying and carryType==Item.TYPE.Fuel:
			canDrop=false#dont drop when refuelling
			refuelEngineObject.prepareRefuel()
	#special case for doors, they should only open when the elevators is not moving, null checks inserted to not crash game
	elif Global.elevator and !Global.elevator.moving and area.owner and ("isDoor" in area.owner):
		area.owner.openDoor()
	elif area.owner and ("interactable" in area.owner):
		interactionObject=area.owner
	
	var outline = area.owner.find_child("Outline")
	if outline != null:
		outline.visible = true

func _on_interaction_area_area_exited(area):
	if area.owner==null:
		return
	if area.owner==interactionObject:
		if interactionObject.name=="EngineDropButton":
			interactionObject.close()
		interactionObject=null
	if area.owner==dispenserObject:
		dispenserObject=null
	if area.owner==brakeObject:
		brakeObject=null
	if area.owner==refuelEngineObject:
		refuelEngineObject.appearNormal()
		refuelEngineObject.stopRefuel()
		refuelEngineObject=null
		canDrop=true
	#null check
	if area.owner and area.owner.get_parent().name=="Doors":
		area.owner.closeDoor()

	var outline = area.owner.find_child("Outline")
	if outline != null:
		outline.visible = false
