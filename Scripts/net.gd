extends Node2D

const ROPE = preload("res://Scenes/Objects/Test/rope.tscn")
@export var texture : Texture2D
var ropeArr : Array
var arrSize
var netPolygon : Polygon2D
var rightEnd
# Called when the node enters the scene tree for the first time.
func _ready():
	var rope = ROPE.instantiate()
	rope.global_position = $AnchorLeft.global_position
	add_child(rope)
	#rope.spawn($AnchorLeft.global_position,$AnchorRight.global_position,true)
	rope.spawnAtBodies($AnchorLeft,$AnchorRight)
	ropeArr = rope.getSegments()
	arrSize = ropeArr.size()
	netPolygon = Polygon2D.new()
	netPolygon.texture = texture
	netPolygon.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	var vertexArray = [$AnchorLeft.global_position]
	for i in arrSize:
		vertexArray.append(ropeArr[i].global_position)
		print("added Vertex "+str(i)+" at pos: "+str(ropeArr[i].global_position))
	netPolygon.polygon = PackedVector2Array(vertexArray)
	add_child(netPolygon)
	print(str(netPolygon))
	rightEnd = ropeArr[arrSize-1]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print("updating")
	if Input.is_action_pressed("right"):
		$AnchorRight.global_position.x += 60 * delta
	if Input.is_action_pressed("left"):
		$AnchorRight.global_position.x -= 60 * delta

	
	for i in range(1,arrSize):
		netPolygon.polygon[i+1]=ropeArr[i].global_position
#	if Input.is_action_pressed("right"):
#		$MarkerRight.posi
	pass
