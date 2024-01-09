extends Node2D

@onready var dots = $Dots.get_children()
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.inventoryMatrix = self
	update()
	pass # Replace with function body.

func getItemColor(type : Item.TYPE):
	match type:
		Item.TYPE.Fuel:
			return Color.RED
		Item.TYPE.Cargo:
			return Color.ORANGE
		Item.TYPE.Scrap:
			return Color.BLUE
		Item.TYPE.Ammo:
			return Color.DARK_MAGENTA
	return null

func update():
	for k in range(16):
		dots[k].set_color(Color.WHITE)
	var i = 0
	for type in Item.TYPE:
		var count = Global.countItem(Item.TYPE[type])
		for j in range(count):
			dots[i+j].set_color(getItemColor(Item.TYPE[type]))
		i+=count
