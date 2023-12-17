extends Node2D

const SEGMENT = preload("res://Scenes/Objects/ropeSegment.tscn")
const END = preload("res://Scenes/Objects/ropeEnd.tscn")
var segments = []
var segmentSize = 24
var ropeMass = 2.0


func spawn(start : Vector2, end : Vector2, pinned = false):
	var length = start.distance_to(end)
	var direction = (end-start).normalized()
	var segmentCount = round(length / segmentSize)
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

func _draw():
	for i in range(1,segments.size()):
		draw_line(segments[i-1].position,segments[i].position,Color.BROWN,4)
	pass

func _process(delta):
	queue_redraw()
