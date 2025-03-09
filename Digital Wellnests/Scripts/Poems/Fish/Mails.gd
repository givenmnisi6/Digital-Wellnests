extends CharacterBody2D

var spamEmail: bool
var pause_status: bool
@export var speed: float
var soundPlayed: bool = false  # Prevent multiple sounds

func _ready() -> void:
	# Calculate the bottom position
	var screen_size = get_viewport().size
	var start_position = Vector2(screen_size.x / 2, screen_size.y)

func _process(delta: float):
	# Move the character upward
	velocity.y = -speed
	move_and_slide()

func setSpeed(newSpeed: float):
	speed = newSpeed

func _on_button_pressed() -> void:
	# Prevent multiple triggers
	if soundPlayed:
		return
	
	soundPlayed = true
	
	# Update the score by calling the parent node's 'mailScore' method
	# Passes 'spamEmail' to indicate whether the email was spam or not
	var score = get_parent().call("mailScore", spamEmail)
	
	# Disable button to prevent multiple clicks
	$Button.disabled = true

	# Play the necessary sound effect and wait for it to finish
	var audio = $Effects
	if spamEmail == false:
		audio.stream = load("res://Audio/Effects/aWrong.wav")
	else:
		audio.stream = load("res://Audio/Effects/aRight2.wav")
	
	# Lower the volume slightly to prevent distortion when multiple sounds play
	audio.volume_db = -3.0
	
	# Play sound
	audio.play()
	
	# Create a nice fade-out effect
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.3)
	
	# Wait for both the tween and the sound to finish (whichever takes longer)
	await audio.finished
	
	# Free the email node after it has been processed and sound finished
	queue_free()

# Visibility Timer of the Mail or Link to appear on the screen
func _on_visibility_timer_timeout() -> void:
	queue_free()
	
func _physics_process(delta):
	if pause_status == true:
		pass
		
	if Input.is_action_just_pressed("pause"):
		pause_status = true
	elif Input.is_action_just_pressed("resume"):
		pause_status = false
