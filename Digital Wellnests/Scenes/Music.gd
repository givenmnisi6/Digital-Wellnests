extends Node2D

var intro = load("res://Audio/Effects/Jungle.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func playMusic():
	$AudioStreamPlayer.stream = intro
	$AudioStreamPlayer.play()

func stopMusic():
	$AudioStreamPlayer.volume_db = -32
	
func increaseVolume():
	$AudioStreamPlayer.volume_db = 4
