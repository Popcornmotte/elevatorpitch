extends Node2D

const SEGMENT = preload("res://Scenes/Objects/ropeSegment.tscn")
const LASTSEGMENT = preload("res://Scenes/Objects/ropeLastSegment.tscn")
const END = preload("res://Scenes/Objects/ropeEnd.tscn")
var segments = []
var segmentSize = 24
var ropeMass = 2.0
var color
var drawStart

func spawn(start : Vector2, end : Vector2, pinned = false, setColor = Color.BLACK):
	color = setColor
	var length = start.distance_to(end)
	var direction = (end-start).normalized()
	var segmentCount = round(length / segmentSize)
	segmentCount = min(segmentCount, 25)
	var angle = Vector2(0,-1).angle_to(direction)
	$Label.text = str(segmentCount)+" segments"
	
	for i in segmentCount:
		var segment
		if(pinned && i == segmentCount-1):
			segment = END.instantiate()
		else:
			segment = SEGMENT.instantiate()
			segment.mass = ropeMass/segmentCount
		segments.append(segment)
		segment.global_position = i * direction * segmentSize
		segment.rotation = angle
		add_child(segment)
		if(i == 0):
			var joint = segment.get_node("Joint")
			joint.node_a = self.get_path()
			joint.node_b = segment.get_path()
		else:
			var joint = segment.get_node("Joint")
			joint.node_a = segments[i-1].get_path()
			joint.node_b = segment.get_path()

#sadly function overloading doesnt seem to work so this one is called different
func spawnAtBodies(startBody : PhysicsBody2D, endBody : PhysicsBody2D, pinned = false, setColor = Color.BLACK):
	color = setColor
	var length = startBody.global_position.distance_to(endBody.global_position)
	var direction = (endBody.global_position-startBody.global_position).normalized()
	var segmentCount = round(length / segmentSize)
	segmentCount = min(segmentCount, 25)
	var angle = Vector2(0,-1).angle_to(direction)
	$Label.text = str(segmentCount)+" segments"
	
	for i in segmentCount:
		var segment
		if(i == segmentCount-1):
			segment = LASTSEGMENT.instantiate()
		else:
			segment = SEGMENT.instantiate()
		segment.mass = ropeMass/segmentCount
		segments.append(segment)
		segment.global_position = i * direction * segmentSize
		segment.rotation = angle
		startBody.add_child(segment)
		if(i == 0):
			var joint = segment.get_node("Joint")
			joint.node_a = startBody.get_path()
			joint.node_b = segment.get_path()
		elif(i == segmentCount-1):
			var joint = segment.get_node("Joint")
			joint.node_a = segments[i-1].get_path()
			joint.node_b = segment.get_path()
			
			var lastJoint = segment.get_node("LastJoint")#PinJoint2D.new()
			#lastJoint.global_position = endBody.global_position
			lastJoint.node_a = endBody.get_path()
			lastJoint.node_b = segment.get_path()
			#segment.add_child(lastJoint)
		else:
			var joint = segment.get_node("Joint")
			joint.node_a = segments[i-1].get_path()
			joint.node_b = segment.get_path()

func getSegments() -> Array :
	return segments

func _draw():
	
	for i in range(1,segments.size()):
		draw_line(segments[i-1].position,segments[i].position,color,4)
	pass

func _process(delta):
	queue_redraw()
