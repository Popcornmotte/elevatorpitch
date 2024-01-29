extends Node

var texts = ["Year 2302:\nEarth is covered in the trash and ruins of the hyperindustrilization of the last centuries.  The ruling upper classes escaped from the giant junkyard up into space.",\
			"The working class usually keeps production busy on the ground. But some particularly risky employment opportunities lets some daring worker catch glimpses of the higher spheres.",\
			"Money still rules the world. More so than ever.\nTo keep illusions up on the Ground, the Elysium program gives hope for the every-man to escape some day too. But only very few occupations allow for ever amassing the needed sum to buy the \"ticket to heaven\"."]
var animation = 0
var textIndex = 0
var clickable = false
var endAnimation = false
@export var posters : Array[Node2D]

func onAnimationFinished(anim_name):
	if endAnimation:
		get_tree().change_scene_to_file("res://Scenes/World/hangar.tscn")
		return
	clickable = true
	$Canvas/MouseIndicatorTimer.start()
	
func onMouseIndicatorTimeout():
	$Canvas/MouseIndicator.visible = true

func _process(delta):
	if clickable:
		if Input.is_action_just_pressed("Grab"):
			$Canvas/MouseIndicatorTimer.start()
			clickable = false
			animation += 1
			animation %= 2
			if textIndex < 2:
				if animation == 0:
					textIndex += 1
					$Canvas/Text.text = texts[textIndex]
			elif animation == 0:
				endAnimation = true
				animation = 2
			if animation == 1:
				if textIndex > 0:
					posters[textIndex-1].visible = false
				posters[textIndex].visible = true
			$Canvas/MouseIndicator.visible = false
			$AnimationPlayer.play(str(animation))
