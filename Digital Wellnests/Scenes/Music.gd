extends Node2D

#Load the music
var intro = load("res://Audio/Effects/Jungle.wav")

func _ready():
	pass 

#Play, stop and increase the Music functions
func playMusic():
	$AudioStreamPlayer.stream = intro
	$AudioStreamPlayer.play()

func stopMusic():
	$AudioStreamPlayer.volume_db = -32
	
func increaseVolume():
	$AudioStreamPlayer.volume_db = 1
