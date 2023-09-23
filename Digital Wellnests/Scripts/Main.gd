extends ColorRect

#Loading the scenes in the Inspector of this Main (ColorRect)
@export var Book: PackedScene
@export var Game: PackedScene
@export var Quiz: PackedScene
@onready var settings = $Control/Settings

var snail: AnimatedSprite2D
var hippo: AnimatedSprite2D
var wolf: AnimatedSprite2D
var cat: AnimatedSprite2D

var iStory: int
var iCount: int
var speed: float
var vol: float

var firstScreen: int
var playerName: String
var positions = []

func _ready():
	name = ""
	#Initial volume
	vol = 10
	$IntroRect.show()
	firstScreen = 0
	speed = 0.4
	iCount = 0
	
	snail = $Control/Snail
	hippo = $Control/Hippo
	wolf = $Control/Wolf
	cat = $Control/Cat
	
	#Play animations at the start 
	snail.play()
	wolf.play()
	hippo.play()
	cat.play()

#Funtion for swapping the Animations
func swap():
	var psTween = get_tree().create_tween()
	var phTween = get_tree().create_tween()
	var pwTween = get_tree().create_tween()
	var pcTween = get_tree().create_tween()

	var ssTween = get_tree().create_tween()
	var shTween = get_tree().create_tween()
	var swTween = get_tree().create_tween()
	var scTween = get_tree().create_tween()

	if iCount == 0:
		psTween.tween_property(snail, "position", Vector2(305,210),0.35)
		phTween.tween_property(hippo, "position", Vector2(622, 410), 0.35)
		pcTween.tween_property(wolf, "position", Vector2(355, 415), 0.35)
		pwTween.tween_property(cat, "position", Vector2(115 , 410), 0.35)
		
		ssTween.tween_property(snail, "scale", Vector2(1,1), 0.3)
		shTween.tween_property(hippo, "scale", Vector2(0.4,0.4), 0.3)
		swTween.tween_property(wolf, "scale", Vector2(0.5,0.5), 0.3)
		scTween.tween_property(cat, "scale", Vector2(0.47,0.47), 0.3)
		
		snail.play()
		wolf.stop()
		hippo.stop()
		cat.stop()
		
		$Story.bbcode_text = "[center]Safety Snail’s e-mails[/center]"
	#Happy Hippo Story
	elif iCount == 1:
		psTween.tween_property(snail, "position", Vector2(78, 380), 0.35)
		phTween.tween_property(hippo, "position", Vector2(355,239), 0.35)
#		pwTween.tween_property(wolf, "position", Vector2(622,400), 0.3)

		pcTween.tween_property(wolf, "position", Vector2(630, 410), 0.35)
		pwTween.tween_property(cat, "position", Vector2(395, 430), 0.35)
		

		ssTween.tween_property(snail, "scale", Vector2(0.6,0.6), 0.3)
		shTween.tween_property(hippo, "scale", Vector2(0.8,0.8), 0.3)
		swTween.tween_property(wolf, "scale", Vector2(0.5,0.5), 0.3)
		scTween.tween_property(cat, "scale", Vector2(0.5,0.5), 0.3)
		
		snail.stop()
		wolf.stop()
		hippo.play()
		cat.stop()
		
		$Story.bbcode_text = "[center]Happy Hippo[/center]"
	#Wolf
	elif iCount == 2:
		psTween.tween_property(snail, "position", Vector2(345, 405), 0.35)
		phTween.tween_property(hippo, "position", Vector2(100, 400), 0.35)
		pwTween.tween_property(wolf, "position", Vector2(355,239), 0.35)
		scTween.tween_property(cat, "position", Vector2(630, 410), 0.35)
		
		ssTween.tween_property(snail, "scale", Vector2(0.6,0.6), 0.3)
		shTween.tween_property(hippo, "scale", Vector2(0.4,0.4), 0.3)
		swTween.tween_property(wolf, "scale", Vector2(1,1), 0.3)
		scTween.tween_property(cat, "scale", Vector2(0.47,0.47), 0.3)
		
		snail.stop()
		wolf.play()
		hippo.stop()
		cat.stop()
		
		$Story.bbcode_text = "[center]Wolf, Hyena and Fox[/center]"
		
	else:
		psTween.tween_property(snail,  "position", Vector2(590, 380), 0.35)
		#phTween.tween_property(hippo, "position", Vector2(100, 400), 0.3)
		phTween.tween_property(hippo, "position",Vector2(345, 423), 0.35)
		pwTween.tween_property(wolf, "position", Vector2(78, 400), 0.35)
		pcTween.tween_property(cat, "position", Vector2(400,250), 0.35)
		
		ssTween.tween_property(snail, "scale", Vector2(0.6,0.6), 0.3)
		shTween.tween_property(hippo, "scale", Vector2(0.4,0.4), 0.3)
		swTween.tween_property(wolf, "scale", Vector2(0.4,0.4), 0.3)
		scTween.tween_property(cat, "scale", Vector2(0.9,0.9), 0.3)
		
		snail.stop()
		wolf.stop()
		hippo.stop()
		cat.play()

		$Story.bbcode_text = "[center]Cyber Cat[/center]"

func _on_arrow_right_gui_input(event):
	if event is InputEventMouseButton and InputEventScreenTouch and event.pressed:
			if iCount == 3:
				iCount = 0
			else:
				iCount += 1
			
			#name = "Cat"
			if iCount == 0:
				name = "Snail"
			elif iCount == 1:
				name = "Hippo"
			elif iCount == 2:
				name = "Wolf"
			elif iCount == 3:
				name = "Cat"
			
			get_node("Effects").stream = load("res://Audio/Voice/" + name + "0.wav")
			get_node("Effects").play()
			
			swap()

func _on_arrow_left_gui_input(event):
	if event is InputEventMouseButton and InputEventScreenTouch and event.pressed:
			if iCount == 0:
				iCount = 3
			else:
				iCount -= 1

			if iCount == 0:
				name = "Snail"
			elif iCount == 1:
				name = "Hippo"
			elif iCount == 2:
				name = "Wolf"
			elif iCount == 3:
				name = "Cat"
			
			get_node("Effects").stream = load("res://Audio/Voice/" + name + "0.wav")
			get_node("Effects").play()
			
			swap()

func _on_s_button_pressed():
	if iCount == 0:
		get_node("Effects").stream = load("res://Audio/Effects/click.wav")
		get_node("Effects").play()
		iStory = 0
		startBook()


func _on_h_button_pressed():
	if iCount == 1:
		get_node("Effects").stream = load("res://Audio/Effects/click.wav")
		get_node("Effects").play()
		iStory = 1
		#get_tree().change_scene_to_packed(Book)
		startBook()

func _on_w_button_pressed():
	if iCount == 2:
		get_node("Effects").stream = load("res://Audio/Effects/click.wav")
		get_node("Effects").play()
		iStory = 2
		startBook()

func _on_c_button_pressed():
	if iCount == 3:
		get_node("Effects").stream = load("res://Audio/Effects/click.wav")
		get_node("Effects").play()
		iStory = 3
		startBook()

func startBook():
	var tween = get_tree().create_tween()
	var audioS = get_node("AudioStreamPlayer") as AudioStreamPlayer
	
	tween.tween_property(audioS,"volume", -45, 1)
	
	var bookInstance = Book.instantiate() as ColorRect

	get_node("Control").scale = Vector2(0.01, 0.01)
	bookInstance.iStory = iStory
#
#	bookInstance.set("iStory", iStory)
	add_child(bookInstance)
#	tween.tween_property(bookInstance, "modulate", Color(1,1,1,0), 0.5)
	#get_node("NameLabel").show()
	#get_node("NameLabel").show()

func startQuiz():
	var tween = get_tree().create_tween()
	var audioS = get_node("AudioStreamPlayer") as AudioStreamPlayer
	tween.tween_property(audioS,"volume_db", (8*vol) -80, 1)
	
	#var quizInstance : TextureRect
	
	#var quiz_instance = Quiz.instance()
	var quizInstance = Quiz.instantiate()
	quizInstance.iStory = iStory
	#quiz_instance.set("iStory", iStory)
	add_child(quizInstance)
	#tween.tween_property(quizInstance, "modulate", Color(1,1,1,0), 0.5)
	#get_node("NameLabel").show()

func startGame():
	@warning_ignore("unused_variable")
	var tween = get_tree().create_tween()
	
#	var gameInstance : TextureRect
#
#	gameInstance = Game.instance()
	var gameInstance = Game.instantiate()
	gameInstance.gameIndex = iStory
	gameInstance.set("iStory", iStory)
	add_child(gameInstance)
	#tween.tween_property(gameInstance, "modulate", Color.RED, 0.5)
	#get_node("NameLabel").show()
	

#func returnToMain():
#	$Control.scale = Vector2(1, 1) 

func _on_intro_timer_timeout():
	var intro = $IntroRect/Intro
	
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
		$IntroTimer.wait_time = 0.5
		$IntroTimer.start()
		
		var intro_rectS = get_node("IntroRect")
		var tween = get_tree().create_tween()
		
		tween.tween_property(intro_rectS, "modulate",Color(1,1,1,0), 0.5)
		
	else:
		$IntroTimer.stop()
		$IntroRect.queue_free()
	firstScreen += 1


func _on_settings_button_down():
	get_node("Effects").stream = load("res://Audio/Effects/click.wav")
	get_node("Effects").play()
	get_node("SettingsPage").show()

func _on_h_slider_value_changed(volu: float):
	vol = volu
	var ans = -80 * pow(0.646, vol) + 1
	get_node("AudioStreamPlayer").volume_db = ans
	get_node("Effects").volume_db = ans
	get_node("Effects").stream = load("res://Audio/Effects/aRight2.wav")
	get_node("Effects").play()

func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()

func _on_settings_mouse_entered():
	settings.scale = Vector2(1.05, 1.05)

func _on_settings_mouse_exited():
	settings.scale = Vector2(1, 1)


func _on_back_button_down():
	get_node("Effects").stream = load("res://Audio/Effects/click.wav")
	get_node("Effects").play()
	get_node("SettingsPage").hide()
