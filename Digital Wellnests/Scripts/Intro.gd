extends Node2D
# This variable stores the index of the first screen to be displayed
var firstScreen: int
# This exported variable stores a reference to the Main scene
@export var Main: PackedScene 

# This script is used as the intro scene
func _ready():
	# Play the music using the Music scene
	Music.playMusic() 
	# This variable stores the volume of the sound. It is initially set to 10
	var vol: float = 10
	# Show the picture of the game
	$IntroRect.show()
	# Set the index of the first screen to be displayed
	firstScreen = 0

# This code first displays the game image the does the transitions
func _on_intro_timer_timeout():
	# Get the Intro texture which is the game image
	var intro = $IntroRect/Intro
	if firstScreen == 0:
		# Set the wait time of the timer to 1 second and start it
		$IntroTimer.wait_time = 1
		$IntroTimer.start()
		
		# Create a tween to fade in the Intro texture over 0.5 seconds
		var tween = get_tree().create_tween()
		# Fully transparent white
		tween.tween_property(intro, "modulate",Color(1,1,1,0), 0.5)
		
	elif firstScreen == 1:
		# Set the wait time of the timer to 3 seconds and start it
		$IntroTimer.wait_time = 3
		$IntroTimer.start()
		
		# Change the texture of the Intro texture to the NWU image
		intro.texture = load("res://Images/NWU.png")
		# Create a tween to fade in the Intro texture over 1 second
		var tween = get_tree().create_tween()
		# White with full opacity
		tween.tween_property(intro, "modulate",Color(1,1,1,1), 1)
		
	elif firstScreen == 2:
		# Set the wait time of the timer to 1 second and start it
		$IntroTimer.wait_time = 1
		$IntroTimer.start()
		
		# Create a tween to fade out the IntroRect over 0.5 seconds
		var intro_rectS = get_node("IntroRect")
		var tween = get_tree().create_tween()
		# White with full opacity
		tween.tween_property(intro_rectS, "modulate",Color(1,1,1,1), 0.5)

	elif firstScreen == 3:
		# Stop the timer
		$IntroTimer.stop()
		# Queue the IntroRect to be freed, removes the node and put the Main scene
		$IntroRect.queue_free()
		# Wait for 1 second and modulate before loading the main scene
		# Instantiate (load) the Main scene and add it as a child node
		$IntroTimer.wait_time = 1
		var tween = get_tree().create_tween()
		tween.tween_property(intro, "modulate",Color(1,1,1,0), 0.5)
		
		var mainInstance = Main.instantiate()
		add_child(mainInstance)
	# Increment the index of the first screen to be displayed
	firstScreen += 1

func _on_audio_stream_player_finished():
	# Play the audio stream
	$AudioStreamPlayer.play()
