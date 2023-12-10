extends Node

@export var crateSpawnArea : CollisionShape2D
var cratePrefab = preload("res://Scenes/Objects/Items/crate.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var spawnAreaRect = crateSpawnArea.shape.get_rect()
	var i = 0
	while(i < Global.inventory.size()):
		if(Global.inventory[i].type != Item.TYPE.Cargo):
			i += 1
		else:
			Global.inventory.remove_at(i)
			var newCrate = cratePrefab.instantiate()
			add_child(newCrate)
			var spawnPos = Vector2(0,0)
			spawnPos.x = randf_range(spawnAreaRect.position.x, spawnAreaRect.position.x + spawnAreaRect.size.x)
			spawnPos.y = randf_range(spawnAreaRect.position.y, spawnAreaRect.position.y + spawnAreaRect.size.y)
			newCrate.global_position = spawnPos + crateSpawnArea.global_position
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
