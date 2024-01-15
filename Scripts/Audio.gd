extends Node

# Preload Music tracks like this 
#const jazz = preload("res://Assets/Sounds/Music/Hard_Boiled_by_Kevin_MacLeod.ogg")
#const frankenstein = preload("res://Assets/Sounds/music/Of Far Different Nature - Frankenstein (CC-BY).ogg")
const hangar = preload("res://Assets/Audio/music/kitchenDanceHangarTune.mp3")
const calmClimb = preload("res://Assets/Audio/music/boringBeat.mp3")
const mainMenu = preload("res://Assets/Audio/music/mainMenu.mp3")

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
	for child in $sfxLocalized.get_children():
		if child.playing == false:
			child.stream = clip
			child.global_position = pos
			child.play()
			if loop:
				return child
			break

func playMusic(music : String):
	match music:
		"hangar":
			$music/MusicPlayer.stream = hangar
		"calm":
			$music/MusicPlayer.stream = calmClimb
		"mainMenu":
			$music/MusicPlayer.stream = mainMenu
		_:
			printerr("[Audio.playMusic] track name "+music+" not recognized")
			$music/MusicPlayer.stream = null
	$music/MusicPlayer.play()


func stopMusic():
	$music/MusicPlayer.stop()
