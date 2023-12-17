extends Node2D

const SEGMENT = preload("res://Scenes/Objects/ropeSegment.tscn")
var segments = []
var segmentSize = 16


func spawn(start : Vector2, end : Vector2):
	var length = start.distance_to(end)
	var direction = (end-start).normalized()
	var segmentCount = round(length / segmentSize)
	var angle = Vector2(0,-1).angle_to(direction)
	
	for i in segmentCount:
		var segment = SEGMENT.instantiate()
		segments.append(segment)
		add_child(segment)
		segment.position = i * direction * segmentSize
		segment.rotation = angle
		if(i == 0):
			var joint = segment.get_node("Joint")
			joint.node_a = self
			joint.node_b = segments
		else:
			var joint = segment.get_node("Joint")
			joint.node_a = segments[i-1]
			joint.node_b = segments
