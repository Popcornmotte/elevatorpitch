extends Node

#Put here all variables that make sense to be globally accessible


#the elevator will assign itself to this variable
var elevator : Node2D
#current Level Scene. since it is different than root
var level

var inventoryMaxSize = 16
var inventory = Array()

func addToInventory(item : Item) -> bool:
	if inventory.size() < inventoryMaxSize:
		inventory.append(item)
		return true
	else:
		return false

func takeFromInventory(type : Item.TYPE):
	for i in inventory.size():
		if inventory[i].type == type:
			return inventory.pop_at(i)
	return null

#for letting enemies efficiently check for Cargo to steal
func checkForCargo() -> bool:
	return (inventory.any(func(item : Item): return(item.type == Item.TYPE.Cargo)))
	
