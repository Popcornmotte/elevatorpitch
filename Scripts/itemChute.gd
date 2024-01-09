extends Node2D

const shreddingNoise = preload("res://Assets/Audio/sfx/shredder.wav")

func _on_area_2d_area_entered(area):
	checkForItem(area)

func _on_area_2d_body_entered(body):
	checkForItem(body)

func checkForItem(thing):
	if thing is Item:
		addItem(thing, thing.type)
		return
	if thing is ClawGrabbable and thing.isItem:
		addItem(thing, thing.item)
		return
	if thing is Enemy and thing.yields != Item.TYPE.Cargo:
		addItem(thing, thing.yields)
		return
	if thing.get_parent() != null:
		checkForItem(thing.get_parent())

func addItem(thing : Node2D, type : Item.TYPE):
	Global.addToInventory(Item.new(type))
	thing.call_deferred("queue_free")
	if type != Item.TYPE.Cargo:
		Audio.playSfxLocalized(shreddingNoise, global_position)
	return
