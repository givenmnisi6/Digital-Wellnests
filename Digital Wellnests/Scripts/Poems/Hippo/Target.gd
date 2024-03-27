extends Area2D

# Variables to track whether the target was hit and if it's a bully
var hit: bool
var bully: bool

func _ready():
	# Start the animation for the target
	$TargetFace.play()
	# Initialize hit status to false
	hit = false

func _process(delta):
	pass

# Called when the timer for the target expires
func _on_target_timer_timeout():
	# Remove the target from the scene
	queue_free()

# Called when the timer for display expires
func _on_disp_timer_timeout():
	# Remove the target from the scene
	queue_free()

# Called when the button is pressed to interact with the target
func _on_button_pressed():
	# Reset hit status
	hit = false
	# Stop the display timer
	$DispTimer.stop()
	# Update the target's animation
	$TargetFace.animation = $TargetFace.animation + "1"
	# Set hit status to true
	hit = true
	# Start the target timer
	$TargetTimer.start()
	# Get the audio player node
	var ap = $Effects
	# Set the audio stream based on whether it's a bully or not
	if bully:
		ap.stream = load("res://Audio/Effects/aRight2.wav")
	else:
		ap.stream = load("res://Audio/Effects/aWrong.wav")
	# Play the audio
	ap.play()
	# Call the parent function to calculate the hit
	var pa = get_parent().call("calcHit", bully)
