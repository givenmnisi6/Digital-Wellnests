extends ColorRect

# Loading the scenes in the Inspector of this Main (ColorRect)
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
	# Initialize variables
	name = ""
	speed = 0.4
	iCount = 0

	# Assign animated sprite nodes
	snail = $Control/Snail
	hippo = $Control/Hippo
	wolf = $Control/Wolf
	cat = $Control/Cat

	# Play animations at the start
	snail.play()
	wolf.play()
	hippo.play()
	cat.play()

#Funtion for swapping the Animations
func swap():
	# Create tweens for each animated sprite's position and scale
	var psTween = get_tree().create_tween()
	var phTween = get_tree().create_tween()
	var pwTween = get_tree().create_tween()
	var pcTween = get_tree().create_tween()

	var ssTween = get_tree().create_tween()
	var shTween = get_tree().create_tween()
	var swTween = get_tree().create_tween()
	var scTween = get_tree().create_tween()

	# Safety Snail's e-mails
	if iCount == 0:
		# Move and scale each sprite to their respective positions and scales
		psTween.tween_property(snail, "position", Vector2(305,210), 0.35)
		phTween.tween_property(hippo, "position", Vector2(622, 410), 0.35)
		pcTween.tween_property(wolf, "position", Vector2(355, 415), 0.35)
		pwTween.tween_property(cat, "position", Vector2(115 , 410), 0.35)
		
		ssTween.tween_property(snail, "scale", Vector2(1,1), 0.3)
		shTween.tween_property(hippo, "scale", Vector2(0.4,0.4), 0.3)
		swTween.tween_property(wolf, "scale", Vector2(0.5,0.5), 0.3)
		scTween.tween_property(cat, "scale", Vector2(0.47,0.47), 0.3)
		
		# Play and stop animations accordingly
		snail.play()
		wolf.stop()
		hippo.stop()
		cat.stop()
		
		$Story.bbcode_text = "[center]Safety Snail’s e-mails[/center]"

	# Happy Hippo 
	elif iCount == 1:
		# Set tweens for positions and scales
		psTween.tween_property(snail, "position", Vector2(78, 380), 0.35)
		phTween.tween_property(hippo, "position", Vector2(355,239), 0.35)
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

	# Wolf, Hyena and Fox
	elif iCount == 2:
		# Set tweens for positions and scales
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
	
	# Cyber Cat
	else:
		# Set tweens for positions and scales
		psTween.tween_property(snail,  "position", Vector2(590, 380), 0.35)
		phTween.tween_property(hippo, "position",Vector2(345, 423), 0.35)
		pwTween.tween_property(wolf, "position", Vector2(78, 400), 0.35)
		pcTween.tween_property(cat, "position", Vector2(400,239), 0.35)

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
	# Check if the event is a mouse button press and screen touch
	if event is InputEventMouseButton and InputEventScreenTouch and event.pressed:
		# Increment iCount with wrap-around
		if iCount == 3:
			iCount = 0
		else:
			iCount += 1
		
		# Set the name based on the current iCount value
		if iCount == 0:
			name = "Snail"
		elif iCount == 1:
			name = "Hippo"
		elif iCount == 2:
			name = "Wolf"
		elif iCount == 3:
			name = "Cat"

		# Load and play the corresponding audio file
		$Effects.stream = load("res://Audio/Voice/" + name + "0.wav")
		$Effects.play()

		# Perform sprite swapping
		swap()

func _on_arrow_left_gui_input(event):
	# Check if the event is a mouse button press and screen touch
	if event is InputEventMouseButton and InputEventScreenTouch and event.pressed:
		# Decrement iCount with wrap-around
		if iCount == 0:
			iCount = 3
		else:
			iCount -= 1

		# Set the name based on the current iCount value
		if iCount == 0:
			name = "Snail"
		elif iCount == 1:
			name = "Hippo"
		elif iCount == 2:
			name = "Wolf"
		elif iCount == 3:
			name = "Cat"

		# Load and play the corresponding audio file
		$Effects.stream = load("res://Audio/Voice/" + name + "0.wav")
		$Effects.play()

		# Perform sprite swapping
		swap()

func _on_s_button_pressed():
	# Check if iCount is 0
	if iCount == 0:
		# Play the click sound effect
		Music.clickSfx()

		# Set iStory to 0 and start the book
		iStory = 0
		startBook()


func _on_h_button_pressed():
	# Check if iCount is 1
	if iCount == 1:
		# Load and play the click sound effect
		Music.clickSfx()

		# Set iStory to 1 and start the book
		iStory = 1
		startBook()

func _on_w_button_pressed():
	# Check if iCount is 2
	if iCount == 2:
		# Play the click sound effect
		Music.clickSfx()

		# Set iStory to 2 and start the book
		iStory = 2
		startBook()

func _on_c_button_pressed():
	# Check if iCount is 3
	if iCount == 3:
		# Play the click sound effect
		Music.clickSfx()

		# Set iStory to 2 and start the book
		iStory = 3
		startBook()

func startBook():
	var tween = get_tree().create_tween()

	var bookInstance = Book.instantiate() 
	$Control.scale = Vector2(0.01, 0.01)
	Music.stopMusic()
	
	bookInstance.iStory = iStory
	add_child(bookInstance)

func startQuiz():
	var tween = get_tree().create_tween()

	var quizInstance = Quiz.instantiate()
	
	Music.playMusic()
	quizInstance.iStory = iStory
	add_child(quizInstance)

func startGame():
	var tween = get_tree().create_tween()

	var gameInstance = Game.instantiate()
	gameInstance.gameIndex = iStory

	gameInstance.set("iStory", iStory)
	add_child(gameInstance)

func returnToMain() -> void:
	$Control.scale = Vector2(1, 1)

#func _on_settings_button_down():
	#Music.clickSfx()
	#$SettingsPage.show()

func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()

#func _on_settings_mouse_entered():
	#settings.scale = Vector2(1.05, 1.05)

#func _on_settings_mouse_exited():
	#settings.scale = Vector2(1, 1)

func _on_back_button_down():
	Music.clickSfx()
	$SettingsPage.hide()


func _on_sfx_slider_drag_started():
	Music.valueChangedSfx()


func _on_exit_pressed():
	Music.clickSfx()
	$ExitPage.show()
	#get_tree().quit()


func _on_settings_pressed():
	Music.clickSfx()
	$SettingsPage.show()


func _on_q_button_button_down():
	Music.clickSfx()
	$ExitPage.hide()


func _on_dq_button_pressed():
	Music.clickSfx()
	get_tree().quit()
