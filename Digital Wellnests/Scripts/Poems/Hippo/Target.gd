extends Area2D

# Variables to track whether the target was hit and if it's a bully
var hit: bool
var bully: bool
var canClick = true

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
	# If clicking is not allowed, exit this function
	if not canClick:
		return

	# Reset hit status
	hit = false
	# Stop the display timer
	$DispTimer.stop()

	# Update the target's animation
	var prevAnim = $TargetFace.animation
	$TargetFace.animation = prevAnim + "1"
	
	# If the previous animation is the same as the next one disable canClick
	if $TargetFace.animation == prevAnim + "1":
		# Prevent multiple clicks
		canClick = false

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
