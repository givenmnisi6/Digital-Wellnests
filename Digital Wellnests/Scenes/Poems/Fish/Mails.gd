extends RigidBody2D

var spamEmail: bool
#var spamLink: bool
var _screenSize: Vector2
#var safeEmail: bool
#var safeLink: bool

func _ready() -> void:
	_screenSize = get_viewport().get_size()
	
func _on_button_pressed() -> void:
	var score = get_parent().call("mailScore", spamEmail)
	var audio = $Effects
	
	if spamEmail == false:
		print("Spam email detected")
		audio.stream = load("res://Audio/Effects/aWrong.wav")
		audio.play()
	else:
		audio.stream = load("res://Audio/Effects/aRight2.wav")
		audio.play()
	
	#_on_timer_timeout()
	#audio.play()
	await _on_effects_finished() # Wait for the audio to finish
	queue_free()
	
	#print("spamEmail is set to: ", self.spamEmail)

	#elif safeEmail and safeLink:
		#notSpam()

func _on_visibility_timer_timeout() -> void:
	queue_free()

func spam():
	$Effects.stream = load("res://Audio/Effects/aWrong.wav")
	$Effects.play()
	
	#var audio = $Effects
	#audio.stream = load("res://Audio/Effects/aRight2.wav")
	#audio.play()

#func notSpam():
	#$Sfx.stream = load("res://Audio/Effects/aRight2.wav")
	#$Sfx.play()


func _on_timer_timeout() -> void:
	queue_free()


func _on_effects_finished() -> void:
	pass # Replace with function body.
