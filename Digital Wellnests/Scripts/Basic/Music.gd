extends Node2D

func _ready():
	# Load the intro music
	var intro = load("res://Audio/Effects/Jungle.wav")
	$AudioStreamPlayer.stream = intro
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.connect("finished",Callable(self, "_on_audio_stream_player_finished"))
	

# Increase the volume of the music
func playMusic():
	$AudioStreamPlayer.volume_db = 0
	
# Stop the music
func stopMusic():
	$AudioStreamPlayer.volume_db = -22

func clickSfx():
	# Load the click sound effect
	var click = load("res://Audio/Effects/click.wav")
	$SoundEffects.stream = click
	$SoundEffects.play()

func valueChangedSfx():
	# Load the sound effect for value change
	var changed = load("res://Audio/Effects/aRight2.wav")
	$SoundEffects.stream = changed
	$SoundEffects.play()

func _on_audio_stream_player_finished():
	# When the audio stream player finishes playing, restart the intro music
	var intro = load("res://Audio/Effects/Jungle.wav")
	$AudioStreamPlayer.stream = intro
	$AudioStreamPlayer.play()

func wrongSfx():
	# Load the wrong sound effect
	var wrong = load("res://Audio/Effects/aWrong.wav")
	$SoundEffects.stream = wrong
	$SoundEffects.play()

func rightSfx():
	# Load the correct sound effect
	var wrong = load("res://Audio/Effects/aRight2.wav")
	$SoundEffects.stream = wrong
	$SoundEffects.play()
