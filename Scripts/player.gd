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
var carryingScrap=false
var carryPos=Vector2(8,1)
var controlPlayer=true # the player is controllable when the arms are not, get this information from the elevator if it exists
var carryType= Item.TYPE.Fuel
var startRepair=false#block dropping of scrap when in vicinity of repair station
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var cameraMargins = 0.0
var sfx
var interactionObject:Node2D #object that the player is interacting with

func _ready():
	Global.player = self
	cameraMargins = $PlayerCam.get_drag_margin(0)
	zoomIn(startZoomedIn)

func playPlayerSound(clip : AudioStream):
	if(sfx):
		if(!sfx.playing):
			sfx = Audio.playSfx(clip,false)
	else:
		sfx=Audio.playSfx(clip,true)
		
func flipAnimation(direction):
	if direction>0:
		sprite.flip_h=false
		fuelSprite.position=carryPos
		scrapSprite.position=carryPos
	else:
		sprite.flip_h=true
		fuelSprite.position=carryPos*Vector2(-1,1)
		scrapSprite.position=carryPos*Vector2(-1,1)

func zoomIn(state : bool):
	if state:
		zoomAnimation.play("zoom_in")
		for side in range(0,4):
			$PlayerCam.set_drag_margin(side, cameraMargins)
	else:
		zoomAnimation.play("zoom_out")
		for side in range(0,4):
			$PlayerCam.set_drag_margin(side, 0)
	pass

func jump(direction):
	#jumping only allowed when on floor and space bar pressed
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpVelocity
	
# Function that needs to be called after move and slide to provide collision with rigidbodies
func collideWithRigidbodies():
	for i in get_slide_collision_count():
		var c=get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal()*pushForce)

func addCarryable(thing):
	carryables.push_back(thing)
	
func removeCarryable(thing):
	carryables.erase(thing)

func pickUpObject():
	if carrying:#in case the player is already holding something, nothing else should be picked up
		return false
	var thing = carryables.pop_back()
	var typeArg = thing.getType()
	if typeArg==Item.TYPE.Fuel:
		fuelSprite.visible=true
		carryType=Item.TYPE.Fuel
	if typeArg==Item.TYPE.Scrap:
		scrapSprite.visible=true
		carryType=Item.TYPE.Scrap
		carryingScrap=true
	carrying=true
	thing.queue_free()
	Audio.playSfx(PICKUPSOUND)
	return true

func dropObject():
	if carrying:
		Audio.playSfx(DROPSOUND)
	if carryType==Item.TYPE.Fuel:
		fuelSprite.visible=false
		carrying=false
		var loadedFuel=FUEL.instantiate()
		get_parent().add_child(loadedFuel)
		loadedFuel.global_position=fuelSprite.get_global_position()
	if carryType==Item.TYPE.Scrap and not startRepair:# do not drop scrap when interacting with repair
		scrapSprite.visible=false
		carrying=false
		carryingScrap=false
		var loadedScrap=SCRAP.instantiate()
		get_parent().add_child(loadedScrap)
		loadedScrap.global_position=scrapSprite.get_global_position()


func move(direction):
	if direction:
		if is_on_floor():
			#flip animation if necessary
			sprite.play("walk")
			flipAnimation(direction)
			playPlayerSound(WALKINGSOUND)
		#allow the player to also move mid jump
		velocity.x = direction * speed
	else:
		if is_on_floor():
			sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, speed)

func removeScrap():#called when carrying scrap and repairing something
	scrapSprite.visible=false
	carrying=false
	carryingScrap=false
	
func fall(direction,delta):
	velocity.y += gravity * delta
	sprite.play("jump")
	flipAnimation(direction)
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
	if Input.is_action_just_pressed("interact"):
		#pick up object
		if carrying:
			dropObject()
		elif carryables.size() > 0:
			pickUpObject()
		#check if player is interacting with something
		if interactionObject:
			interactionObject.use()
	
	if carrying and Input.is_action_pressed("repair") and interactionObject:
		interactionObject.repair()
			
func _physics_process(delta):
	if Global.elevator:
		controlPlayer=!Global.elevator.controlArms#control player when not controlling arms
	if controlPlayer:	
		#direction is used to flip animations accordingly
		var direction = Input.get_axis("left", "right")
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
		jump(direction)
		move(direction)
		move_and_slide()
		collideWithRigidbodies()
		

func _on_interaction_area_area_entered(area):
	interactionObject=area.owner


func _on_interaction_area_area_exited(area):
	if area.owner==interactionObject:
		interactionObject=null
