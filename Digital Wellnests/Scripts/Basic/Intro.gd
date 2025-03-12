extends Node2D

# This variable stores the index of the first screen to be displayed
var firstScreen: int = 0

# This exported variable stores a reference to the Main scene
@export var Main: PackedScene

# This script is used as the intro scene
func _ready():
	# Show the picture of the game
	$IntroRect.show()

	# Start the intro timer
	$IntroTimer.start()

# This code first displays the game image then does the transitions
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
		tween.tween_property(intro, "modulate", Color(1, 1, 1, 0), 0.5)
		
	elif firstScreen == 1:
		# Set the wait time of the timer to 3 seconds and start it
		$IntroTimer.wait_time = 3
		$IntroTimer.start()
		
		# Change the texture of the Intro texture to the NWU image
		intro.texture = load("res://Images/NWU.png")
		
		# Create a tween to fade in the Intro texture over 1 second
		var tween = get_tree().create_tween()
		# White with full opacity
		tween.tween_property(intro, "modulate", Color(1, 1, 1, 1), 1)

	elif firstScreen == 2:
		# Create main scene instance in advance but keep it invisible
		var mainInstance = Main.instantiate()
		mainInstance.modulate = Color(1, 1, 1, 0)  # Start fully transparent
		add_child(mainInstance)
		
		# Set a much shorter wait time to reduce waiting
		$IntroTimer.wait_time = 0.5
		$IntroTimer.start()
		
		# Create a tween to fade out the IntroRect over 0.5 seconds
		var introRect = get_node("IntroRect")
		var tween = get_tree().create_tween()
		# Fade to transparent instead of opaque
		tween.tween_property(introRect, "modulate", Color(1, 1, 1, 0), 0.5)
		
		# Pre-load main scene with a brief delay to ensure no blank frame
		# This starts the fade-in slightly before the fade-out completes
		var mainTween = get_tree().create_tween()
		mainTween.tween_interval(0.3) # Brief delay before starting fade-in
		mainTween.tween_property(mainInstance, "modulate", Color(1, 1, 1, 0.3), 0.2) # Start fading in slightly

	elif firstScreen == 3:
		# Stop the timer since we're at the final step
		$IntroTimer.stop()
		
		# Get the already-created main instance
		var mainInstance = get_children().filter(func(node): return node != $IntroRect and node != $IntroTimer and node != $AudioStreamPlayer)[0]
		
		# Create a tween for quick fade in
		var tween = get_tree().create_tween()
		
		# Fade in the main scene faster (0.5 seconds instead of 1.0)
		tween.tween_property(mainInstance, "modulate", Color(1, 1, 1, 1), 0.5)
		
		# After fade completes, clean up the intro elements
		tween.tween_callback(func(): 
			$IntroRect.queue_free()
		)
		
	# Increment the index of the first screen to be displayed
	firstScreen += 1

func _on_audio_stream_player_finished():
	# Play the audio stream (loop it)
	$AudioStreamPlayer.play()
