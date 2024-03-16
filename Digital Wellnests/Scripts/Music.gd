extends Node2D

# Load the music
var intro = load("res://Audio/Effects/Jungle.wav")

func _ready():
	pass 

# Play the music
func playMusic():
	$AudioStreamPlayer.stream = intro
	$AudioStreamPlayer.play()

# Stop the music
func stopMusic():
	$AudioStreamPlayer.volume_db = -40
	
# Increase the volume of the music
func increaseVolume():
	$AudioStreamPlayer.volume_db = 1
