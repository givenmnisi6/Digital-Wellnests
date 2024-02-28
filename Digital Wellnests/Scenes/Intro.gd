extends Node2D
var vol: float
var firstScreen: int
@export var Main: PackedScene

func _ready():
	Music.playMusic() 
	vol = 10
	$Transition/IntroRect.show()
	firstScreen = 0

func _on_intro_timer_timeout():
	var intro = $Transition/IntroRect/Intro
	if firstScreen == 0:
		$IntroTimer.wait_time = 1
		$IntroTimer.start()
		
		var tween = get_tree().create_tween()
		tween.tween_property(intro, "modulate",Color(1,1,1,0), 0.5)
		
	elif firstScreen == 1:
		$IntroTimer.wait_time = 3
		$IntroTimer.start()
		
		intro.texture = load("res://Images/NWU.png")
		var tween = get_tree().create_tween()
		tween.tween_property(intro, "modulate",Color(1,1,1,1), 1)
		
	elif firstScreen == 2:
		$IntroTimer.wait_time = 1
		$IntroTimer.start()
		
		var intro_rectS = get_node("IntroRect")
		var tween = get_tree().create_tween()
		
		tween.tween_property(intro_rectS, "modulate",Color(2,1,1,0), 0.1)
	
	elif firstScreen == 3:
		$IntroTimer.stop()
		$Transition/IntroRect.queue_free()
		var mainInstance = Main.instantiate()
		add_child(mainInstance)
	firstScreen += 1
	


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
