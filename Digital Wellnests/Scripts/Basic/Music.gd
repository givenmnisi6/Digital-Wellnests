extends Node2D

# Load the music and sound effects
var intro = load("res://Audio/Effects/Jungle.wav")
var click = load("res://Audio/Effects/click.wav")
var changed = load("res://Audio/Effects/aRight2.wav")
var wrong = load("res://Audio/Effects/aWrong.wav")
var right = changed  # Use the same resource instead of loading twice

func _ready():
	# Load the intro music
	$AudioStreamPlayer.stream = intro
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.connect("finished",Callable(self, "_on_audio_stream_player_finished"))

# Increase the volume of the music
func playMusic():
	$AudioStreamPlayer.volume_db = -5
	
# Stop the music
func stopMusic():
	$AudioStreamPlayer.volume_db = -10

# Helper function to play sound effects
func playSfx(sound):
	# Play the given sound effect
	$SoundEffects.stream = sound
	$SoundEffects.play()

func clickSfx():
	# Play the click sound effect
	playSfx(click)

func valueChangedSfx():
	# Play the sound effect for value change
	playSfx(changed)

func _on_audio_stream_player_finished():
	# When the audio stream player finishes playing, restart the intro music
	$AudioStreamPlayer.play()

func wrongSfx():
	# Play the wrong sound effect
	playSfx(wrong)

func rightSfx():
	# Play the correct sound effect
	playSfx(right)
