extends Control

var pageLock: bool
var totalVerse: int
var currentVerse: int
var verseCount: int
var story: Array
var iStory: int
var charCount: int
var totCharCount: int
var totCount: int

func _ready():
	var anim = $Pages/Animation
	var animShad = $Pages/AnimationShadow
	
	anim.frame = 0
	animShad.frame = 0
	grab_click_focus()
	
	# Prints the value of iStory (which is not defined in this snippet, so it will likely throw an error)
	#print(iStory)
	verseCount = 0
	charCount = 0
	totCount = 0
	totCharCount = 0
	
	# Array of the story
	story = ["Snail", "Fish", "Elephant", "Wolf", "Hippo", "Cat"]
	
	# Start the story function
	
	#showInstruction()
	storyStart()


func showInstruction():
	$Pages.hide()
	$Panel.show()

func storyStart():
	var anim = $Pages/Animation
	var anim2 = $Pages/AnimationShadow
	$Panel/AnimationPlayer.play("PopUp")
	# Show and play animation 
	anim.show()
	anim.play()

	# Show and play animation shadow
	anim2.show()
	anim2.play()
	
	# Adjust the scale and position of the animations based on the value of iStory
	if iStory == 2:
		anim.scale = Vector2(1, 1)
		anim2.scale = Vector2(1.05, 1.05)
	elif iStory == 1:
		anim.position = Vector2(180+25, 285)
		anim2.position = Vector2(180+25, 285)

	var poemText = $Pages/poemText
	
	# Clear the text
	poemText.text = ""
	
	# Set the current verse to 0
	currentVerse = 0
	
	# Animation to play when a certain story is selected
	anim.animation = story[iStory] + str(totCount)
	anim2.animation = story[iStory] + str(totCount)
	
	# To play sound when a story is loading, "Safety Snail Emails"
	var audioPlayer = $AudioStreamPlayer
	var audioPath = "res://Audio/Voice/" + story[iStory] + str(totCount) + ".wav"
	
	if ResourceLoader.exists(audioPath):
		audioPlayer.stream = ResourceLoader.load(audioPath)
		audioPlayer.play()

	# Frame that is displayed
	$Pages/PageTurn.frame = 48 

	# Load Story
	loadStory(1)
	
	pageLock = false

func closeInstructions():
	$Panel.hide()
	#queue_free()
				

#func _input(event: InputEvent):
	#if event is InputEventMouseButton and InputEventScreenTouch:# and event.pressed:
		##print("Click")
		#if event.pressed:
			#closeInstructions()
#
		#if !pageLock:
			## If the paragraphs are less than 3
			#if currentVerse < 3:
				## Increment the current verse and total count
				#currentVerse += 1
				#totCount += 1
				#
				## If the animation exists, set it as the current animation
				#if $Pages/Animation.sprite_frames.has_animation(story[iStory] + str(totCount)):
					#$Pages/Animation.animation = story[iStory] + str(totCount)
				#if $Pages/AnimationShadow.sprite_frames.has_animation(story[iStory] + str(totCount)):
					#$Pages/AnimationShadow.animation = story[iStory] + str(totCount)
#
				## Load and play an audio stream
				#var audioStreamPlayer = $AudioStreamPlayer
				#var audioFilePath = "res://Audio/Voice/" + story[iStory] + str(totCount) + ".wav"
#
				#if ResourceLoader.exists(audioFilePath):
					#var audioStream = ResourceLoader.load(audioFilePath)
					#audioStreamPlayer.stream = audioStream
					#audioStreamPlayer.play()
				#
				## Start the word timer
				#$WordTimer.start()
				#pageLock = true
			#else:
				#$AudioStreamPlayer.stop()
				#get_parent().get_node("Effects").stream = ResourceLoader.load("res://Audio/Effects/pageflip.wav")
				#get_parent().get_node("Effects").play()
#
				#var pageTurn = $Pages/PageTurn
				#pageTurn.play()
				#
				##Start the page turn from zero
				#pageTurn.frame = 0
				#
				## If the total verse count is less than or equal to 3, start the quiz and free the current node
				#if totalVerse <= 3:
					#get_parent().call("startQuiz")
					#queue_free()
					#
				 ## Lock the page
				#pageLock = true
				#
				## Increment the total count
				#totCount += 1
				#
				## If the total verse count is greater than 3
				#if totalVerse > 3:
					## Reset the current verse and decrement the total verse count
					#currentVerse = 0
					#totalVerse -= 3
					##print(totalVerse)
					#
					#loadStory(totalVerse / 3 + 2)
				#
				#if iStory == 1 and totCount == 8:
					#currentVerse = 0
					##print("AAA")
					#var anim = $Pages/Animation
					#anim.position = Vector2(180+25, 285)
					#var anim2 = $Pages/AnimationShadow
					#anim2.position = Vector2(180+25, 285)

func _on_word_timer_timeout():
	pageLock = false
	
	var poemText = $Pages/poemText
	var text = poemText.text

	# For revealing the words of the Poem
	if (charCount + 1 < text.length() && (text[charCount] != '\n' || text[charCount + 1] != '\n') || charCount + 1 == text.length()):
		# Still displaying text character by character
		poemText.visible_characters = poemText.visible_characters + 1
		charCount += 1
		
		# Keep button disabled while still displaying
		setContinue(false)
		
		$WordTimer.start()
	else:
		# Text display is complete - enable continue button
		pageLock = false
		charCount += 1
		poemText.visible_characters = charCount
		$Pages/WaitTimer.start()
		
func _on_page_turn_animation_finished():
	pageLock = false
	# Enabling the continue button when page turn animation is complete
	setContinue(true)


func loadStory(num: int):
	var poemTitle = $Pages/Title
	var poemText = $Pages/poemText
	
	# Opening the poems and reading them
	var txtFile = FileAccess.open("res://Poems/" + story[iStory] + ".txt", FileAccess.READ)
	
	# Get the entire text content of the poem file
	var poem = txtFile.get_as_text()
	
	# Extracting the total number of verses and poem content
	if num == 1:
		totalVerse = int(poem.substr(0, poem.find("-"))) # Extract the total number of verses from the start of the text
	poem = poem.substr(poem.find("-") + 1) # Remove the total verse count from the poem text
	
	#print("Total number of paragraphs or verses: " + str(totalVerse))
	
	# Setting the title of the poem
	poemTitle.text = poem.substr(0, poem.find("\n\n")) # Set the poem title text
	poemTitle.bbcode_text = "[center]" + poem.substr(0, poem.find("\n")) + "[/center]"
	poem = poem.substr(poem.find("\n") + 2)
	
	totCharCount += charCount
	charCount = 0
	
	var indx = getIndex(poem, "\n", 3 * num)
	if indx == -1:
		poem = poem.substr(totCharCount)
	else:
		poem = poem.substr(totCharCount, indx)
	
	# Starting the poem
	# Removing leading newlines from the poem text
	while poem.begins_with('\n'):
		poem = poem.substr(1)
	
	poemText.text = poem              # Clear the poem text
	poemText.visible_characters = 0   # Start with no characters visible
	currentVerse = 0                  # Reset the current verse counter

# Function to get the index of the nth occurrence of a substring in a string
func getIndex(s: String, t: String, n: int) -> int:
	var count = 0
	for i in range (s.length() - 1):
		if s[i] == t and s[i + 1] == t:
			count += 1
			if count == n:
				return i
	return -1

func _on_page_turn_frame_changed():
	if $Pages/PageTurn.frame == 12:
		# Reset the visible characters to 0 when the page turn frame reaches 12
		$Pages/poemText.visible_characters = 0
	elif $Pages/PageTurn.frame == 22:
		# Check if the animation exists and set it as the current animation when the page turn frame reaches 22
		if $Pages/Animation.sprite_frames.has_animation(story[iStory] + str(totCount)):
			$Pages/Animation.animation = story[iStory] + str(totCount)
		if $Pages/AnimationShadow.sprite_frames.has_animation(story[iStory] + str(totCount)):
			$Pages/AnimationShadow.animation = story[iStory] + str(totCount)


func _on_back_pressed() -> void:
	# Return to the parent scene which is the Main Menu one
	get_parent().returnToMain()
	Music.clickSfx()
	queue_free()
	Music.playMusic()

func _on_okay_button_pressed() -> void:
	$GameInstructions.hide()
	$Pages.show()
	storyStart()

func _on_info_button_mouse_entered() -> void:
	#$GameInstructions.show()
	$Panel/AnimationPlayer.play("PopUp")
	$Panel.show()

func _on_info_button_mouse_exited() -> void:
	#$GameInstructions.hide()
	$Panel/AnimationPlayer.play_backwards("PopUp")
	$Panel.hide()

func _on_wait_timer_timeout() -> void:
	setContinue(true)
