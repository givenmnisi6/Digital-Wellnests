extends CharacterBody2D

var spamEmail: bool
var pause_status: bool
@export var speed: float  

func _ready() -> void:
	 # Calculate the bottom position
	var screen_size = get_viewport().size
	var start_position = Vector2(screen_size.x / 2, screen_size.y)

func _process(delta: float):
	# Move the character upward
	velocity.y = -speed
	move_and_slide()

func setSpeed(new_speed: float):
	speed = new_speed

func _on_button_pressed() -> void:
	# Update the score by calling the parent node's 'mailScore' method
	# Passes 'spamEmail' to indicate whether the email was spam or not
	var score = get_parent().call("mailScore", spamEmail)

	# Play the necessary sound effect depending on whether the email was spam
	if spamEmail == false:
		Music.wrongSfx()
	else:
		Music.rightSfx()
	# Free the email node after it has been processed
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
