extends Node

# Preload Music tracks like this 
#const jazz = preload("res://Assets/Sounds/Music/Hard_Boiled_by_Kevin_MacLeod.ogg")
#const frankenstein = preload("res://Assets/Sounds/music/Of Far Different Nature - Frankenstein (CC-BY).ogg")

#Loop should probably be never utilized
func playSfx(clip : AudioStream, loop : bool = false):
	for child in $sfx.get_children():
		if child.playing == false:
			child.stream = clip
			child.play()
			if loop:
				return child
			break

#play SFX at specific point. Untested.
func playSfxLocalized(clip : AudioStream, pos : Vector2 ,loop : bool = false):
	for child in $sfx.get_children():
		if child.playing == false:
			child.stream = clip
			child.global_position = pos
			child.play()
			if loop:
				return child
			break

#func playMusic(music : String):
#	match music:
#		"jazz":
#			$music/musicPlayer.stream = jazz
#	$music/musicPlayer.play()


func stopMusic():
	$music/musicPlayer.stop()
