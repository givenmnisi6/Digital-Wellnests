extends Node2D

# Load the music
var intro = load("res://Audio/Effects/Jungle.wav")

func _ready():
	$AudioStreamPlayer.stream = intro
	$AudioStreamPlayer.volume_db = 0
	$AudioStreamPlayer.play()
	print("Initial volume: ", $AudioStreamPlayer.volume_db)

# Increase the volume of the music
func increaseVolume():
	$AudioStreamPlayer.volume_db = 0
	
# Stop the music
func stopMusic():
	$AudioStreamPlayer.volume_db = -40
	print("Stop Volume: ", $AudioStreamPlayer.volume_db)
