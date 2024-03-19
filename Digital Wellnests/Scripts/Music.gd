extends Node2D


func _ready():
	var intro = load("res://Audio/Effects/Jungle.wav")
	$AudioStreamPlayer.stream = intro
	$AudioStreamPlayer.play()

# Increase the volume of the music
func playMusic():
	$AudioStreamPlayer.volume_db = 0
	
# Stop the music
func stopMusic():
	$AudioStreamPlayer.volume_db = -40

func clickSfx():
	var click = load("res://Audio/Effects/click.wav")
	$SoundEffects.stream = click
	$SoundEffects.play()

func valueChangedSfx():
	var changed = load("res://Audio/Effects/aRight2.wav")
	$SoundEffects.stream = changed
	$SoundEffects.play()

