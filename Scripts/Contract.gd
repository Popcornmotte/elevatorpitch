extends Node

class_name Contract

var shortDescription : String
var description : String
var pay : int
var risk : int #0 (low), 1 (medium) or 2 (high)
var destination : int
#var optionalObjective : 

func _init():
	shortDescription = "Lorem"
	description = "Lorem Ipsum"
	pay = 10
	risk = 0
	destination = 0
