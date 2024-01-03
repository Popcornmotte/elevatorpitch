extends GenericDestroyable

const ROPE = preload("res://Scenes/Objects/Test/rope.tscn")
@export var texture : Texture2D
@export var ropeColor = Color.BLACK
@export var speed = 400
@export var maxDistance = 600
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
# Called when the node enters the scene tree for the first time.
func _ready():
	rope = ROPE.instantiate()
	rope.global_position = $AnchorLeftFollower.global_position
	add_child(rope)
	#rope.spawn($AnchorLeft.global_position,$AnchorRight.global_position,true)
	rope.spawnAtBodies($AnchorLeftFollower,$AnchorRightFollower,ropeColor)
	ropeArr = rope.getSegments()
	arrSize = ropeArr.size()
	netPolygon = Polygon2D.new()
	netPolygon.texture = texture
	netPolygon.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	var vertexArray = [$AnchorLeftFollower.global_position]
	for i in arrSize:
		vertexArray.append(ropeArr[i].global_position)
		print("added Vertex "+str(i)+" at pos: "+str(ropeArr[i].global_position))
	netPolygon.polygon = PackedVector2Array(vertexArray)
	add_child(netPolygon)
	print(str(netPolygon))
	rightEnd = ropeArr[arrSize-1]
	
	#quickly hide and retract:
	hide()
	rope.process_mode = Node.PROCESS_MODE_DISABLED
	setDeployment(false)


func setDeployment(deploy : bool):
	if !animating:
		animating = true
		if deploy:
			rope.process_mode = Node.PROCESS_MODE_INHERIT
			show()
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
	
	if !animating and get_parent().controlArms:
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
				#$AnimationPlayer.play("retract")
				#extended = false
				setDeployment(false)
			else:
				#$AnimationPlayer.play_backwards("retract")
				#extended = true
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
		hide()
		rope.process_mode = Node.PROCESS_MODE_DISABLED
	animating = false


func _on_timer_timeout():
	$AnimationPlayer.play("retract")
