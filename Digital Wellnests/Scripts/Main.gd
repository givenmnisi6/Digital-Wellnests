extends Control

# Loading the scenes in the Inspector of this Main (ColorRect)
@export var Book: PackedScene
@export var Game: PackedScene
@export var Quiz: PackedScene
@onready var settings = $Settings

var snail: AnimatedSprite2D
var hippo: AnimatedSprite2D
var wolf: AnimatedSprite2D
var cat: AnimatedSprite2D
var fish: AnimatedSprite2D
var elephant: AnimatedSprite2D

var iStory: int
var iCount: int
var speed: float
var vol: float

var playerName: String
var positions = []

var musicBus = AudioServer.get_bus_index("Music")

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
	fish = $Control/Fish
	elephant = $Control/Elephant

	# Play animations at the start
	snail.play()
	wolf.play()
	hippo.play()
	cat.play()
	fish.play()
	elephant.play()

# Function for swapping the Animations
func swap():
	# Create tweens for each animated sprite's position and scale
	var psTween = get_tree().create_tween()
	var phTween = get_tree().create_tween()
	var pwTween = get_tree().create_tween()
	var pcTween = get_tree().create_tween()
	var pfTween = get_tree().create_tween()
	var peTween = get_tree().create_tween()

	var ssTween = get_tree().create_tween()
	var shTween = get_tree().create_tween()
	var swTween = get_tree().create_tween()
	var scTween = get_tree().create_tween()
	var sfTween = get_tree().create_tween()
	var seTween = get_tree().create_tween()

	# Safety Snail's e-mails
	if iCount == 0:
		# Move and scale each sprite to their respective positions and scales
		psTween.tween_property(snail, "position", Vector2(305,210), 0.35)
		phTween.tween_property(hippo, "position", Vector2(184, 404), 0.35)
		pcTween.tween_property(wolf, "position", Vector2(365, 427), 0.35)
		pwTween.tween_property(cat, "position", Vector2(79, 349), 0.35)
		pwTween.parallel().tween_property(fish, "position", Vector2(660 , 339), 0.35)
		peTween.tween_property(elephant, "position", Vector2(534.141, 389), 0.35)
		
		ssTween.tween_property(snail, "scale", Vector2(1,1), 0.3)
		shTween.tween_property(hippo, "scale", Vector2(0.34,0.34), 0.3)
		swTween.tween_property(wolf, "scale", Vector2(0.4,0.4), 0.3)
		scTween.tween_property(cat, "scale", Vector2(0.34,0.34), 0.3)
		sfTween.parallel().tween_property(fish, "scale", Vector2(0.39,0.39), 0.3)
		seTween.tween_property(elephant, "scale", Vector2(0.45,0.45), 0.3)
		
		# Play and stop animations accordingly
		snail.play()
		wolf.stop()
		hippo.stop()
		cat.stop()
		fish.stop()
		elephant.stop()
		
		$Story.bbcode_text = "[center]Safety Snail’s e-mails[/center]"
	
	# Lucky the Fish
	elif iCount == 1:
		# Move and scale each sprite to their respective positions and scales
		psTween.tween_property(snail, "position", Vector2(52, 339), 0.35)
		phTween.tween_property(hippo, "position", Vector2(368, 438), 0.35)
		pcTween.tween_property(wolf, "position", Vector2(530, 405), 0.35)
		pwTween.tween_property(cat, "position", Vector2(220 , 420), 0.35)
		pfTween.parallel().tween_property(fish, "position", Vector2(360, 230), 0.35)
		peTween.tween_property(elephant, "position", Vector2(665, 355), 0.35)
		
		ssTween.tween_property(snail, "scale", Vector2(0.47, 0.47), 0.3)
		shTween.tween_property(hippo, "scale", Vector2(0.3, 0.3), 0.3)
		swTween.tween_property(wolf, "scale", Vector2(0.4, 0.4), 0.3)
		scTween.tween_property(cat, "scale", Vector2(0.37, 0.37), 0.3)
		sfTween.parallel().tween_property(fish, "scale", Vector2(0.94, 0.94), 0.3)
		seTween.tween_property(elephant, "scale", Vector2(0.42, 0.42), 0.3)
		
		# Play and stop animations accordingly
		snail.stop()
		wolf.stop()
		hippo.stop()
		cat.stop()
		fish.play()
		elephant.stop()
		
		$Story.bbcode_text = "[center]Lucky the Fish[/center]"

	# Elephant and his shoe
	elif iCount == 2:
		# Move and scale each sprite to their respective positions and scales
		psTween.tween_property(snail, "position", Vector2(180 , 389), 0.35)
		phTween.tween_property(hippo, "position", Vector2(530, 405), 0.35)
		pcTween.tween_property(wolf, "position", Vector2(665 , 355), 0.35)
		pwTween.tween_property(cat, "position", Vector2(378, 445), 0.35)
		pwTween.parallel().tween_property(fish, "position", Vector2(59, 350), 0.35)
		peTween.tween_property(elephant, "position", Vector2(365, 220), 0.35)
		
		ssTween.tween_property(snail, "scale", Vector2(0.45, 0.45), 0.3)
		shTween.tween_property(hippo, "scale", Vector2(0.3, 0.3), 0.3)
		swTween.tween_property(wolf, "scale", Vector2(0.4, 0.4), 0.3)
		scTween.tween_property(cat, "scale", Vector2(0.37, 0.37), 0.3)
		sfTween.parallel().tween_property(fish, "scale", Vector2(0.35, 0.35), 0.3)
		seTween.tween_property(elephant, "scale", Vector2(1.09, 1.09), 0.3)
		
		# Play and stop animations accordingly
		snail.stop()
		wolf.stop()
		hippo.stop()
		cat.stop()
		fish.stop()
		elephant.play()
		
		$Story.bbcode_text = "[center]Elephant and his shoe[/center]"

	# Wolf, Hyena and Fox
	elif iCount == 3:
		# Set tweens for positions and scales
		psTween.tween_property(snail, "position", Vector2(320, 420), 0.35)
		phTween.tween_property(hippo, "position", Vector2(650 , 355), 0.35)
		pwTween.tween_property(wolf, "position", Vector2(355, 239), 0.35)
		scTween.tween_property(cat, "position", Vector2(520, 405), 0.35)
		pwTween.parallel().tween_property(fish, "position",  Vector2(180 , 396), 0.35)
		peTween.tween_property(elephant, "position", Vector2(55, 350), 0.35)

		ssTween.tween_property(snail, "scale", Vector2(0.45, 0.45), 0.3)
		shTween.tween_property(hippo, "scale", Vector2(0.3, 0.3), 0.3)
		swTween.tween_property(wolf, "scale", Vector2(1, 1), 0.3)
		scTween.tween_property(cat, "scale", Vector2(0.37, 0.37), 0.3)
		sfTween.parallel().tween_property(fish, "scale", Vector2(0.39, 0.39), 0.3)
		seTween.tween_property(elephant, "scale", Vector2(0.4, 0.4), 0.3)

		snail.stop()
		wolf.play()
		hippo.stop()
		cat.stop()
		fish.stop()
		elephant.stop()
		
		$Story.bbcode_text = "[center]Wolf, Hyena and Fox[/center]"
		
	# Happy Hippo 
	elif iCount == 4:
		# Set tweens for positions and scales
		psTween.tween_property(snail, "position", Vector2(470, 393), 0.35)
		phTween.tween_property(hippo, "position", Vector2(355, 239), 0.35)
		pcTween.tween_property(wolf, "position", Vector2(59, 350), 0.35)
		pwTween.tween_property(cat, "position", Vector2(665, 355), 0.35)
		pwTween.parallel().tween_property(fish, "position", Vector2(330, 425), 0.35)
		peTween.tween_property(elephant, "position", Vector2(193, 400), 0.35)

		ssTween.tween_property(snail, "scale", Vector2(0.46, 0.46 ), 0.3)
		shTween.tween_property(hippo, "scale", Vector2(0.8, 0.8), 0.3)
		swTween.tween_property(wolf, "scale", Vector2(0.4, 0.4), 0.3)
		scTween.tween_property(cat, "scale", Vector2(0.37, 0.37), 0.3)
		sfTween.parallel().tween_property(fish, "scale", Vector2(0.39, 0.39), 0.3)
		seTween.tween_property(elephant, "scale", Vector2(0.4, 0.4), 0.3)

		snail.stop()
		wolf.stop()
		hippo.play()
		cat.stop()
		fish.stop()
		elephant.stop()
		
		$Story.bbcode_text = "[center]Happy Hippo[/center]"

	# Cyber Cat
	else :
		# Set tweens for positions and scales
		psTween.tween_property(snail,  "position", Vector2(627, 340), 0.35)
		phTween.tween_property(hippo, "position", Vector2(70, 350), 0.35)
		pwTween.tween_property(wolf, "position", Vector2(215, 400), 0.35)
		pcTween.tween_property(cat, "position", Vector2(400, 239), 0.35)
		pwTween.parallel().tween_property(fish, "position", Vector2(520, 400), 0.35)
		peTween.tween_property(elephant, "position", Vector2(370, 420), 0.35)

		ssTween.tween_property(snail, "scale", Vector2(0.45, 0.45), 0.3)
		shTween.tween_property(hippo, "scale", Vector2(0.3, 0.3), 0.3)
		swTween.tween_property(wolf, "scale", Vector2(0.4, 0.4), 0.3)
		scTween.tween_property(cat, "scale", Vector2(0.9, 0.9), 0.3)
		sfTween.parallel().tween_property(fish, "scale", Vector2(0.39, 0.39), 0.3)
		seTween.tween_property(elephant, "scale", Vector2(0.4, 0.4), 0.3)

		snail.stop()
		wolf.stop()
		hippo.stop()
		cat.play()
		fish.stop()
		elephant.stop()

		$Story.bbcode_text = "[center]Cyber Cat[/center]"

func _on_arrow_right_gui_input(event):
	# Check if the event is a mouse button press or screen touch
	if event is InputEventMouseButton and InputEventScreenTouch and event.pressed:
		Music.clickSfx()
		# Increment iCount with wrap-around
		if iCount == 5:
			iCount = 0
		else:
			iCount += 1
		
		# Set the name based on the current iCount value
		if iCount == 0:
			name = "Snail"
		elif iCount == 1:
			name = "Fish"
		elif iCount == 2:
			name = "Elephant"
		elif iCount == 3:
			name = "Wolf"
		elif iCount == 4:
			name = "Hippo"
		elif iCount == 5:
			name = "Cat"

		# Load and play the corresponding audio file
		$Effects.stream = load("res://Audio/Voice/" + name + "0.wav")
		$Effects.play()

		# Perform sprite swapping
		swap()

func _on_arrow_left_gui_input(event):
	# Check if the event is a mouse button press or screen touch
	if event is InputEventMouseButton and InputEventScreenTouch and event.pressed:
		Music.clickSfx()
		# Decrement iCount with wrap-around
		if iCount == 0:
			iCount = 5
		else:
			iCount -= 1

		# Set the name based on the current iCount value
		if iCount == 0:
			name = "Snail"
		elif iCount == 1:
			name = "Fish"
		elif iCount == 2:
			name = "Elephant"
		elif iCount == 3:
			name = "Wolf"
		elif iCount == 4:
			name = "Hippo"
		elif iCount == 5:
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

func _on_f_button_pressed():
	# Check if iCount is 1
	if iCount == 1:
		# Play the click sound effect
		Music.clickSfx()

		# Set iStory to 1 and start the book
		iStory = 1
		startBook()

func _on_e_button_pressed():
	# Check if iCount is 2
	if iCount == 2:
		# Play the click sound effect
		Music.clickSfx()

		# Set iStory to 2 and start the book
		iStory = 2
		startBook()

func _on_w_button_pressed():
	# Check if iCount is 3
	if iCount == 3:
		# Play the click sound effect
		Music.clickSfx()

		# Set iStory to 3 and start the book
		iStory = 3
		startBook()

func _on_h_button_pressed():
	# Check if iCount is 4
	if iCount == 4:
		# Load and play the click sound effect
		Music.clickSfx()

		# Set iStory to 4 and start the book
		iStory = 4
		startBook()

func _on_c_button_pressed():
	# Check if iCount is 5
	if iCount == 5:
		# Play the click sound effect
		Music.clickSfx()

		# Set iStory to 5 and start the book
		iStory = 5
		startBook()

func startBook():
	# Instantiate the book scene
	var bookInstance = Book.instantiate() 
	
	# Scale down the Control node
	$Control.scale = Vector2(0.01, 0.01)
	
	# Stop the music
	Music.stopMusic()
	
	# Set the iStory value of the book instance
	bookInstance.iStory = iStory
	
	# Add the book instance as a child node
	add_child(bookInstance)

func startQuiz():
	# Instantiate the quiz scene
	var quizInstance = Quiz.instantiate()
	
	# Play the music
	Music.playMusic()
	
	# Set the iStory value of the quiz instance
	quizInstance.iStory = iStory
	
	# Hiding all the instructions, story name, exit and settings
	$ColorRect.scale = Vector2(0.01, 0.01)
	$Story.hide()
	$Instructions.hide()
	$Exit.hide()
	$Settings.hide()

	# Add the quiz instance as a child node
	add_child(quizInstance)

func startGame():
	# Instantiate the game scene
	var gameInstance = Game.instantiate()
	
	# Set the gameIndex value of the game instance
	gameInstance.gameIndex = iStory
	
	# Set the iStory value of the game instance
	gameInstance.set("iStory", iStory)
	
	# Hiding all the instructions, story name, exit and settings
	$Control.scale = Vector2(0.01, 0.01)
	$Story.hide()
	$Instructions.hide()
	$Exit.hide()
	$Settings.hide()
	
	# Add the game instance as a child node
	add_child(gameInstance)

func returnToMain() -> void:
	# Scale up the Control node
	$Control.scale = Vector2(1, 1)
	$Story.show()
	$Instructions.show()
	$Exit.show()
	$Settings.show()

func _on_audio_stream_player_finished():
	# Play the audio stream again
	$AudioStreamPlayer.play()

func _on_back_pressed():
	# Play the click sound effect
	Music.clickSfx()
	
	# Hide the SettingsPage node
	%AnimationPlayer.play_backwards("PopOut")
	#$SettingsPage.hide()

func _on_sfx_slider_drag_started():
	# Notify that the SFX slider value has changed
	Music.valueChangedSfx()

func _on_exit_pressed():
	# Play the click sound effect
	Music.clickSfx()
	
	# Show the Exit Page
	%ExitAnimationPlayer.play("popExit")
	$ExitPage.show()
	
	# Create a tween for animation
	var twn = get_tree().create_tween()
	
	# Get the yButton and nButton nodes
	var y = $ExitPage/Panel/yButton
	var n = $ExitPage/Panel/nButton

	# Scale up the yButton and nButton nodes
	twn.tween_property(y, "scale", Vector2(1,1), 0.4)
	twn.tween_property(n, "scale", Vector2(1,1), 0.4)

func _on_exit_gui_input(event):
	if (event is InputEventScreenTouch && InputEventMouseButton):
		# Play the click sound effect
		Music.clickSfx()
		
		# Show the ExitPage node
		$ExitPage.show()
		
		# Create a tween for animation
		var twn = get_tree().create_tween()
		
		# Get the yButton and nButton nodes
		var y = $ExitPage/Panel/yButton
		var n = $ExitPage/Panel/nButton
		
		# Scale up the yButton and nButton nodes
		twn.tween_property(y, "scale", Vector2(1,1), 0.4)
		twn.tween_property(n, "scale", Vector2(1,1), 0.4)

func _on_settings_pressed():
	# Play the click sound effect
	Music.clickSfx()
	
	# Show the SettingsPage node
	%AnimationPlayer.play("PopOut")
	$SettingsPage.show()

func _on_n_button_pressed():
	# Play the click sound effect
	Music.clickSfx()
	
	# Hide the ExitPage node
	#$ExitPage.hide()
	%ExitAnimationPlayer.play_backwards("popExit")

func _on_y_button_pressed():
	# Play the click sound effect
	Music.clickSfx()
	
	# Quit the game
	%ExitAnimationPlayer.play_backwards("popExit")
	get_tree().quit()

func _on_sound_button_pressed():
	# Toggle the mute state of the music bus
	AudioServer.set_bus_mute(musicBus, not AudioServer.is_bus_mute(musicBus))
	Music.clickSfx()

func _on_settings_gui_input(event):
	if (event is InputEventScreenTouch && InputEventMouseButton):
		# Play the click sound effect
		Music.clickSfx()
		
		# Show the SettingsPage node
		$SettingsPage.show()
