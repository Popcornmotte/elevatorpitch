extends Node

func _on_area_2d_area_entered(area):
	checkForItem(area)

func _on_area_2d_body_entered(body):
	checkForItem(body)

func checkForItem(thing):
	if thing is Item:
		Global.addToInventory(Item.new(thing.type))
		thing.call_deferred("queue_free")
	if thing is ClawGrabbable and thing.isItem:
		Global.addToInventory(Item.new(thing.item))
		thing.call_deferred("queue_free")
	elif thing.get_parent() != null:
		checkForItem(thing.get_parent())
