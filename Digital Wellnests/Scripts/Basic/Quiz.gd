extends TextureRect

var iStory: int     # Index of the current story
var chosen: int     # Index of the current question
var count: int      # Number of questions to be answered
var points: int     # Player's score
var timerCount: int # Timer for animation sequencing
var questions := {} # Dictionary storing question text (key) and correct answer (value)
var ctrl1: Control  # Reference to the quiz UI
var fq: bool  

func _ready():
	# Initialise quiz UI with animation
	%AnimationPlayer.play("PopOut")
	fq = true
	timerCount = 0
	ctrl1 = $qPlay
	$Screen.texture = load("res://Images/QuizBG.png") 
	
	# Number of questions to be answered
	count = 4

	# Load appropriate question set based on story index
	if iStory == 0:
		# Safety Snail's e-mails
		questions = {
			"Mom?": true,
			"Dad?": true,
			"Friend?": true,
			"Stranger?": false,
			"Unknown?": false,
			"Hidden?": false
			}
		$qPlay/QTitle.bbcode_text = "[center]Should you accept a message from:[/center]"
	elif iStory == 1:
		# Lucky the Fish
		questions = {
			"Best friend?": true,
			"Teacher?": true,
			"Parents?": true,
			"Mysterious website?": false,
			"Surprising offer?": false,
			"Stranger?": false
			}
		$qPlay/QTitle.bbcode_text = "[center]Should you click on a link from:[/center]"
	elif iStory == 2:
		# Elephant and his shoe
		questions = {
			"Librarian?": true,
			"Doctor?": true,
			"Trusted adult?": true,
			"Educational website?": true,
			"Unknown source?": false,
			"Online character?": false,
			"Pop-up adverts?": false
			}
		$qPlay/QTitle.bbcode_text = "[font_size={50}]Should you follow screen time advice from:[/font_size]"
	elif iStory == 3:
		# Wolf, Hyena and Fox
		questions = {
			"P@$$w0rD": true,
			"BigDog!15": true,
			"Red#Car99": true,
			"1234": false,
			"abcd": false,
			"dog": false,
			}
		$qPlay/QTitle.bbcode_text = "[center]Is this a good password?[/center]"
		
	elif iStory == 4:
		# Happy Hippo
		questions = {
			"Tell Mom?": true,
			"Tell Dad?": true,
			"Tell a Teacher?": true,
			"Fight back?": false,
			"Stay quiet?": false,
			"Shout at the bully?": false
			}
		$qPlay/QTitle.bbcode_text = "[center]When I see a bully I will:[/center]"

		# Cyber Cat
	elif iStory == 5:
		questions = {
			"Playing online games?": true,
			"Watching cartoons?": true,
			"Calling your friends?": true,
			"Cyberbullying?": false,
			"Phishing?": false,
			"Identity Theft?": false,
			}
		$qPlay/QTitle.bbcode_text = "[center]Is this online activity legal:[/center]"

	$Effects.stream = load("res://Audio/Voice/Question" + str(iStory) + ".wav")
	$Effects.play()

func _on_effects_finished(): 
	if fq: 
		popQ()
	fq = false

func _on_b_yes_button_down():
	answered(true)

func _on_b_no_button_down():
	answered(false)

func popQ():
	# Randomly select a question from the available questions
	var rand = RandomNumberGenerator.new()
	chosen = randi() % questions.size()
	
	# Display the selected question
	$qPlay/Question.bbcode_text = "[center]" + questions.keys()[chosen] + "[/center]"
	
	# Play audio for the current question
	var name = questions.keys()[chosen]
	name = name.substr(0, name.length() - 1)
	$Effects.stream = load("res://Audio/Voice/" + name + ".wav")
	$Effects.play()

func answered (ans: bool):
	# Process player's answer and update score
	var ap = $Effects
	if ans == questions[questions.keys()[chosen]]:
		# Correct answer handling
		points += 1
		ap.stream = load("res://Audio/Effects/aRight2.wav")
		$rwIndicator.texture = load("res://Images/Right.png")
	else:
		# Wrong answer handling
		ap.stream = load("res://Audio/Effects/aWrong.wav")
		$rwIndicator.texture = load("res://Images/Wrong.png")
	# Play feedback sound and show indicator
	ap.play()
	$rwIndicator.show()
	
	questions.erase(questions.keys()[chosen])
	count -= 1
	$rwTimer.start()

func _on_rw_timer_timeout():
	$rwIndicator.hide()
	if count > 0:
		popQ()
	else:
		var msg = $Message
		ctrl1.hide()
		$Screen.texture = load("res://Images/QuizBG2.png")
		var rnd := RandomNumberGenerator.new()

		# Display appropriate feedback based on score
		if points > 2:
			var i = randi() % 6
			msg.texture = load("res://Images/WD"+ str(i) +".png")
			$Effects.stream = load("res://Audio/Voice/WD" + str(i) + ".wav")
			$Effects.play()
		else:
			# Low score feedback with try again option
			var i = rnd.randi_range(0, 1)
			msg.texture = load("res://Images/NT"+ str(i)+".png")
			$Effects.stream = load("res://Audio/Voice/NT" + str(i) + ".wav")
			$Effects.play()
			var ta: Button = $TryAgain
			var cnt: Button = $Continue
			var twn = get_tree().create_tween()
			twn.tween_property(ta, "scale", Vector2(1, 1), 0.5)
			twn.tween_property(cnt, "scale", Vector2(1, 1), 0.5)
		
		# Create visual score indicators
		for i in range(4):
			var imgIns = TextureRect.new()
			add_child(imgIns)
			@warning_ignore("integer_division")
			var sz = (720 - (10 * 5)) / 4
			
			imgIns.texture = load("res://Images/QuizR" + str(iStory) + ".png")
			imgIns.expand = true
			imgIns.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			imgIns.size = Vector2(sz + 10, sz + 10)
			imgIns.modulate = Color(0, 0, 0, 1)
			imgIns.position = Vector2(i * (sz + 10) + 10, 15)

		if points > 0:
			spawnRes(0)

# Create animated visual indicators for each correct answer
func spawnRes(i: int) -> void:
	var twn = get_tree().create_tween()
	var imgIns: TextureRect = TextureRect.new()
	add_child(imgIns)
	var sz: float = (720 - (10 * 5)) / 4

	imgIns.texture = load("res://Images/QuizR" + str(iStory) + ".png")
	imgIns.expand = true
	imgIns.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	# Animate in the score indicator
	timerCount += 1
	twn.tween_property(imgIns, "size", Vector2(sz,sz), 0.1)
	twn.tween_property(imgIns, "position", Vector2(i*(sz+4.5)+12.7+(sz/30),15+(sz/45)),0.1)
	$Timer.start()

func _on_timer_timeout():
	if timerCount < points:
		spawnRes(timerCount)
	elif timerCount == points:
		#print("a") 
		var msg = $Message
		var twn = get_tree().create_tween()
		timerCount += 1
		#To scale the Message node
		twn.tween_property(msg, "size", Vector2(298, 258), 0.05)
		timerCount += 1
		$Timer.start()
	else:
		# Show the continue/try again buttons
		var cnt = $Continue
		var ta = $TryAgain
		var twn = get_tree().create_tween()
		twn.tween_property(ta, "scale", Vector2(1, 1), 0.5) 
		twn.tween_property(cnt, "scale", Vector2(1, 1), 0.5)

func _on_safety_timer_timeout():
	# Animate in the Yes/No buttons
	var twn = get_tree().create_tween()
	var y = $qPlay/bYes
	var n = $qPlay/bNo
	
	twn.tween_property(y, "scale", Vector2(1,1), 0.4)
	twn.tween_property(n, "scale", Vector2(1,1), 0.4)

func _on_continue_button_down():
	# Return to the game when continue is pressed
	get_parent().call("startGame")
	queue_free()
	Music.clickSfx()

func _on_try_again_button_down():
	# Restart the quiz when try again is pressed
	get_parent().call("startQuiz")
	queue_free()
	Music.clickSfx()
