extends ColorRect

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
	Music.stopMusic()
	grab_click_focus()
	verseCount = 0
	charCount = 0
	totCount = 0
	totCharCount = 0
	story = ["Snail", "Hippo", "Wolf", "Cat"]
	storyStart()

func storyStart():
	var anim = $Animation
	var anim2 = $AnimationShadow

	anim.show()
	anim.play()
	anim2.show()
	anim2.play()
	
	if iStory == 2:
		anim.scale = Vector2(1, 1)
		anim2.scale = Vector2(1.05, 1.05)
	elif iStory == 1:
		anim.position = Vector2(180+25, 285)
		anim2.position = Vector2(180+25, 285)

	var poemText = $Text 
	poemText.text = ""
	currentVerse = 0
	
	#Animation to play when a certain story is selected
	anim.animation = story[iStory] + str(totCount)
	anim2.animation = story[iStory] + str(totCount)
	
		#To Play Sound when game is loading, "Safety Snail Emails"
	var audioPlayer = $AudioStreamPlayer
	var audioPath = "res://Audio/Voice/" + story[iStory] + str(totCount) + ".wav"
	
	if ResourceLoader.exists(audioPath):
		audioPlayer.stream = ResourceLoader.load(audioPath)
		audioPlayer.play()

	#Frame that is displayed
	$PageTurn.frame = 48 

	#Load Story
	loadStory(1)
	pageLock = false

func _input(event: InputEvent):
	if event is InputEventMouseButton and InputEventScreenTouch and event.pressed:
		#print("Click")

		if !pageLock:
			#If the paragraphs are less than 3
			if currentVerse < 3:
				currentVerse += 1
				totCount += 1

				if $Animation.sprite_frames.has_animation(story[iStory] + str(totCount)):
					$Animation.animation = story[iStory] + str(totCount)
				if $AnimationShadow.sprite_frames.has_animation(story[iStory] + str(totCount)):
					$AnimationShadow.animation = story[iStory] + str(totCount)

				var audioStreamPlayer = $AudioStreamPlayer
				var audioFilePath = "res://Audio/Voice/" + story[iStory] + str(totCount) + ".wav"

				if ResourceLoader.exists(audioFilePath):
					var audioStream = ResourceLoader.load(audioFilePath)
					audioStreamPlayer.stream = audioStream
					audioStreamPlayer.play()

				$WordTimer.start()
				pageLock = true
			else:
				$AudioStreamPlayer.stop()
				get_parent().get_node("Effects").stream = ResourceLoader.load("res://Audio/Effects/pageflip.wav")
				get_parent().get_node("Effects").play()

				var pageTurn = $PageTurn
				pageTurn.play()
				
				#Start the page turn from zero
				pageTurn.frame = 0
				
				if totalVerse <= 3:
					#Calling the startQuiz method, to start the Quiz
					get_parent().call("startQuiz")
					queue_free()
				
				pageLock = true
				totCount += 1
				
				if totalVerse > 3:
					currentVerse = 0
					totalVerse -= 3
					#print(totalVerse)
					@warning_ignore("integer_division")
					loadStory(totalVerse / 3 + 2)
				
				if iStory == 1 and totCount == 8:
					var anim = $Animation
					anim.position = Vector2(180+25, 285)
					var anim2 = $AnimationShadow
					anim2.position = Vector2(180+25, 285)

func _on_word_timer_timeout():
	var poemText = $Text
	var text = poemText.text

	#For revealing the words of the Poem
	if (charCount + 1 < text.length() && (text[charCount] != '\n' || text[charCount + 1] != '\n') || charCount + 1 == text.length()):
		#if text[charCount] != '\n':
		$Text.visible_characters = $Text.visible_characters + 1
		charCount += 1
		$WordTimer.start()
	else:
		pageLock = false
		charCount += 1
	$Text.visible_characters = charCount

func _on_page_turn_animation_finished():
	pageLock = false

func _on_ready():
	var anim = $Animation
	var animShad = $AnimationShadow
	
	anim.frame = 0
	animShad.frame = 0

func loadStory(num: int):
	var poemTitle = $Title
	var poemText = $Text
	
	#Opening the poems and reading them
	var txtFile = FileAccess.open("res://Poems/" + story[iStory] + ".txt", FileAccess.READ)
	
	var poem = txtFile.get_as_text()
	
	if num == 1:
		totalVerse = int(poem.substr(0, poem.find("-")))
	poem = poem.substr(poem.find("-") + 1)
	
	#print("Total number of paragraphs or verses: " + str(totalVerse))
	
	poemTitle.text = poem.substr(0, poem.find("\n\n"))
	poemTitle.bbcode_text = "[center]" + poem.substr(0, poem.find("\n")) + "[/center]"
	poem = poem.substr(poem.find("\n") + 2)
	
	totCharCount += charCount
	charCount = 0
	
	var indx = getIndex(poem, "\n", 3 * num)
	if indx == -1:
		poem = poem.substr(totCharCount)
	else:
		poem = poem.substr(totCharCount, indx)
	
	#Starting the poem
	while poem.begins_with('\n'):
		poem = poem.substr(1)
	
	poemText.text = poem
	poemText.visible_characters = 0
	currentVerse = 0

func getIndex(s: String, t: String, n: int) -> int:
	var count = 0
	for i in range (s.length() - 1):
		if s[i] == t and s[i + 1] == t:
			count += 1
			if count == n:
				return i
	return -1


func _on_page_turn_frame_changed():
	if $PageTurn.frame == 12:
		$Text.visible_characters = 0
	elif $PageTurn.frame == 22:
		if $Animation.sprite_frames.has_animation(story[iStory] + str(totCount)):
			$Animation.animation = story[iStory] + str(totCount)
		if $AnimationShadow.sprite_frames.has_animation(story[iStory] + str(totCount)):
			$AnimationShadow.animation = story[iStory] + str(totCount)
