extends RigidBody2D

var coin: bool  # Indicates whether the object is a coin or not

func _ready():
	# Play the ActivitiesAnim animation and select a random frame
	$ActivitiesAnim.play()
	var activities = $ActivitiesAnim.sprite_frames.get_animation_names()
	$ActivitiesAnim.play(activities[randi() % activities.size()])

func coinHit():
	# Play the sound effect for when the object is a coin
	var audio = $Effects
	audio.stream = load("res://Audio/Effects/aRight2.wav")
	audio.play()

func bullHit():
	# Play the sound effect for when the object is not a coin
	var audio = $Effects
	audio.stream = load("res://Audio/Effects/aWrong.wav")
	audio.play()

func _on_area_2d_area_entered(area):
	var audio = $Effects

	if area.is_in_group("Cat"):
		var pa = get_parent().call("calculateHit", coin)
		audio.play()
		if coin:
			coinHit()
		else:
			bullHit()
		await audio.finished  # Wait for the audio to finish playing
		queue_free()  # Free the object from the scene
