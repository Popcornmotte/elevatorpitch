extends Node2D

class_name GenericInteractible

var functioning=true
		
#func interact():
#	if functioning:
#		use()
#	else:
#		repair()

func repair():
	pass

func use():
	pass

func disable():
	functioning=false


