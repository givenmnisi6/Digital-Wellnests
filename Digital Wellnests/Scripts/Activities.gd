extends RigidBody2D

var coin: bool

func _ready():
	$ActivitiesAnim.play()
	var activities = $ActivitiesAnim.sprite_frames.get_animation_names()
	$ActivitiesAnim.play(activities[randi() % activities.size()])

func _process(delta):
	pass

func coinHit():
	var audio = $Effects
	audio.stream = load("res://Audio/Effects/aRight2.wav")
	audio.play()

func bullHit():
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
		#audio.playing = true
		await audio.finished
		queue_free()
