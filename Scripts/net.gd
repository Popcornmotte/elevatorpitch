extends GenericDestroyable

const ROPE = preload("res://Scenes/Objects/Test/rope.tscn")
const ERROR = preload("res://Assets/Audio/sfx/error.wav")
@export var texture : Texture2D
@export var ropeColor = Color.BLACK
@export var speed = 400
@export var maxDistance = 600
@export var locked = false
@onready var lineLeft = $LineLeft
@onready var lineRight = $LineRight
var ropeArr : Array
var arrSize
var netPolygon : Polygon2D
var rightEnd
var rope
var extended = true
var animating = false
var deploying = true
@onready var repairStation=find_child("Repair")
var operatingMode=OPERATIONMODE.Normal

func damaged():
	repairStation.show()
	repairStation.enableOptionalRepair()
	operatingMode=OPERATIONMODE.Damaged

func disable():
	if not extended:#let net fall down in case it is not deployed to show repair area
		setDeployment(true)
	print("global position is ",position)
	super.spawnExplosion(position)
	repairStation.show()
	repairStation.enableRepair()
	operatingMode=OPERATIONMODE.Broken

func repaired():
	repairStation.hide()
	operatingMode=OPERATIONMODE.Normal
	
# Called when the node enters the scene tree for the first time.
func _ready():
	rope = ROPE.instantiate()
	rope.global_position = $AnchorLeftFollower.global_position
	add_child(rope)
	rope.spawnAtBodies($AnchorLeftFollower,$AnchorRightFollower,ropeColor)
	ropeArr = rope.getSegments()
	arrSize = ropeArr.size()
	netPolygon = Polygon2D.new()
	netPolygon.texture = texture
	netPolygon.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	var vertexArray = [$AnchorLeftFollower.global_position]
	for i in arrSize:
		vertexArray.append(ropeArr[i].global_position)
		#print("added Vertex "+str(i)+" at pos: "+str(ropeArr[i].global_position))
	netPolygon.polygon = PackedVector2Array(vertexArray)
	add_child(netPolygon)
	#print(str(netPolygon))
	rightEnd = ropeArr[arrSize-1]
	
	#quickly hide and retract:
	#hide()
	toggleVisibility(false)
	#rope.process_mode = Node.PROCESS_MODE_DISABLED
	setDeployment(false)

func toggleVisibility(state : bool):
	if !state: # meaning visible:
		$LineLeft.hide()
		$LineRight.hide()
		$ArmLeft.hide()
		$ArmRight.hide()
		rope.hide()
		rope.toggleCollision(false)
		netPolygon.hide()
	else:
		$LineLeft.show()
		$LineRight.show()
		$ArmLeft.show()
		$ArmRight.show()
		rope.show()
		rope.toggleCollision(true)
		netPolygon.show()

func setDeployment(deploy : bool):
	if locked:
		return
	animating = true
	if deploy:
		#rope.process_mode = Node.PROCESS_MODE_INHERIT
		toggleVisibility(true)
		deploying = true
		$AnimationPlayer.play_backwards("retract")
		extended = true
	else:
		deploying = false
		extended = false
		$AnimationPlayer.play("RESET")
		$Timer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#rope.global_position = $AnchorLeft.global_position
	#print("updating")
	
	lineLeft.points[1] = $ArmLeft/UpperArm/LowerArm/Tip.global_position - global_position
	lineLeft.points[0] = $AnchorLeftFollower.global_position - global_position
	lineRight.points[1] = $ArmRight/UpperArm/LowerArm/Tip.global_position - global_position
	lineRight.points[0] = $AnchorRightFollower.global_position - global_position

	if !animating and get_parent().controlArms and operatingMode!=OPERATIONMODE.Broken:
		if extended:
			if Input.is_action_pressed("right"):
				if($AnchorRight.position.x < maxDistance):
					$AnchorRight.global_position.x += speed * delta
					$AnchorLeft.global_position.x += speed * delta
				#rope.global_position = $AnchorLeft.global_position
			if Input.is_action_pressed("left"):
				if($AnchorLeft.position.x > -maxDistance):
					$AnchorRight.global_position.x -= speed * delta
					$AnchorLeft.global_position.x -= speed * delta
				#rope.global_position = $AnchorLeft.global_position
		if Input.is_action_just_pressed("Q"):
			if extended:
				setDeployment(false)
			else:
				setDeployment(true)
	
	if Input.is_action_just_pressed("Debug"):
		print("AnchorRight: "+str($AnchorRight.position))
		print("AnchorLeft: "+str($AnchorLeft.position))
		#print("Polygon:")
		#for i in netPolygon.polygon.size():
		#	print(str(i)+": "+str(netPolygon.polygon[i]))
	
	netPolygon.polygon[0]=$AnchorLeftFollower.global_position - global_position
	for i in range(0,arrSize):
		netPolygon.polygon[i+1]=ropeArr[i].global_position - global_position
	pass
	
func _on_animation_player_animation_finished(anim_name):
	if !extended:
		toggleVisibility(false)
		#rope.process_mode = Node.PROCESS_MODE_DISABLED
	animating = false


func _on_timer_timeout():
	$AnimationPlayer.play("retract")
