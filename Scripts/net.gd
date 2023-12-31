extends Node2D

const ROPE = preload("res://Scenes/Objects/Test/rope.tscn")
@export var texture : Texture2D
@export var ropeColor = Color.BLACK
var ropeArr : Array
var arrSize
var netPolygon : Polygon2D
var rightEnd
var rope
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
	pass # Replace with function body.

func _draw():
	#fix for drawing the last part of the rope line 
	draw_line(ropeArr[arrSize-2].global_position - global_position,$AnchorRightFollower.global_position - global_position,ropeColor,4)
	
	for i in range(1,arrSize):
		draw_line(ropeArr[i-1].global_position - global_position,ropeArr[i].global_position - global_position,ropeColor,4)
	#for i in range(1,segments.size()):
	#		draw_line(segments[i-1].position,segments[i].position,color,4)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#rope.global_position = $AnchorLeft.global_position
	#print("updating")
	if Input.is_action_pressed("right"):
		$AnchorRight.global_position.x += 120 * delta
		$AnchorLeft.global_position.x += 120 * delta
		#rope.global_position = $AnchorLeft.global_position
	if Input.is_action_pressed("left"):
		$AnchorRight.global_position.x -= 120 * delta
		$AnchorLeft.global_position.x -= 120 * delta
		#rope.global_position = $AnchorLeft.global_position
	
	if Input.is_action_just_pressed("W"):
		$AnimationPlayer.play("retract")
	if Input.is_action_just_pressed("down"):
		$AnimationPlayer.play_backwards("retract")
	
	queue_redraw()
	
	if Input.is_action_just_pressed("Debug"):
		print("Polygon:")
		for i in netPolygon.polygon.size():
			print(str(i)+": "+str(netPolygon.polygon[i]))
	
	netPolygon.polygon[0]=$AnchorLeftFollower.global_position - global_position
	for i in range(0,arrSize):
		netPolygon.polygon[i+1]=ropeArr[i].global_position - global_position
	pass
