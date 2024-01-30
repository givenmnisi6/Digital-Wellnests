extends Area2D

var hit: bool
var bully: bool

func _ready():
	$TargetFace.play()
	hit = false

func _process(delta):
	pass

func _on_target_timer_timeout():
	queue_free()

func _on_disp_timer_timeout():
	queue_free()

func _on_button_pressed():
	hit = false
	$DispTimer.stop()
	$TargetFace.animation = $TargetFace.animation + "1"
	hit = true
	
	$TargetTimer.start()
	var ap = $Effects
	#var ap = get_parent().get_parent().get_node("Effects") 
	if bully:
		ap.stream = load("res://Audio/Effects/aRight2.wav")
	else:
		ap.stream = load("res://Audio/Effects/aWrong.wav")
	ap.play()
	
	var pa = get_parent().call("calcHit", bully)

