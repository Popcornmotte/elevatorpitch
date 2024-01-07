extends Node

class_name Contract

var shortDescription : String
var description : String
var pay : int
var risk : int #0 (low), 1 (medium) or 2 (high)
var destination : int
#var optionalObjective : 

func _init(descr = "Lorem Ipsum", risk_ = 0):
	shortDescription = "Lorem"
	description = descr
	risk = risk_
	pay = 10+risk*8
	destination = 0
