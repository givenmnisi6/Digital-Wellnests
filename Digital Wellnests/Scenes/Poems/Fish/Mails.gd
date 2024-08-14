extends RigidBody2D

var spamEmail: bool

func _ready() -> void:
	pass
	
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
