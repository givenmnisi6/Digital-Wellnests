extends TextureRect

var iStory: int
var chosen: int
var count: int
var points: int
var timerCount: int
var questions := {} #Dictionary to store the Questions
var ctrl1: Control
var fq: bool 

func _ready():
	fq = true
	timerCount = 0
	ctrl1 = $qPlay
	$Screen.texture = load("res://Images/QuizBG.png") 
	
	#Number of questions to be answered
	count = 4
	if iStory == 0:
		#Snail
		@warning_ignore("unused_variable", "shadowed_variable")
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
		#Hiipo
		@warning_ignore("unused_variable", "shadowed_variable")
		questions = {
			"Tell Mom?": true,
			"Tell Dad?": true,
			"Tell a Teacher?": true,
			"Fight back?": false,
			"Stay quiet?": false,
			"Shout at the bully?": false
			}
		$qPlay/QTitle.bbcode_text = "[center]When I see a bully I will:[/center]"
	elif iStory == 2:
		#Wold
		@warning_ignore("unused_variable", "shadowed_variable")
		questions = {
			"P@$$w0rD": true,
			"BigDog!15": true,
			"Red#Car99": true,
			"1234": false,
			"abcd": false,
			"dog": false,
			}
		$qPlay/QTitle.bbcode_text = "[center]Is this a good password?[/center]"
		#Cat
	elif iStory == 3:
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
	#Randomizing the questions 
	var rand = RandomNumberGenerator.new()
	@warning_ignore("narrowing_conversion")
	chosen = rand.randf_range(0, questions.size() - 1)
	#print("Question number: " + str(chosen), " ", questions.size())
	
	$qPlay/Question.bbcode_text = "[center]" + questions.keys()[chosen] + "[/center]"
	
	#Play the sound of the girl and the tick or cross
	@warning_ignore("shadowed_variable_base_class")
	var name = questions.keys()[chosen]
	name = name.substr(0, name.length() - 1)
	
	$Effects.stream = ResourceLoader.load("res://Audio/Voice/" + name + ".wav")
	$"Effects".play()

func answered (ans: bool):
	#For the ticks
	var ap = $Effects
	#print("I: ", ans, "  A: ", questions[questions.keys()[chosen]])
	if ans == questions[questions.keys()[chosen]]:
		points += 1
		ap.stream = load("res://Audio/Effects/aRight2.wav")
		$rwIndicator.texture = load("res://Images/Right.png")
	else:
		ap.stream = load("res://Audio/Effects/aWrong.wav")
		$rwIndicator.texture = load("res://Images/Wrong.png")
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
		
		if points == 0:
			msg.texture = load("res://Images/NT1.png")
			var ta: Button = $TryAgain
			var twn = get_tree().create_tween()
			twn.tween_property(ta, "scale", Vector2(1, 1), 0.5)
		if points == 1:
			msg.texture = load("res://Images/NT0.png")
			$Effects.stream = load("res://Audio/Voice/NT0.wav")
			$Effects.play()
		if points == 2:
			var i = rnd.randi_range(0, 2)
			msg.texture = load("res://Images/WD" + str(i) + ".png")
			$Effects.stream = load("res://Audio/Voice/WD" + str(i) + ".wav")
			$Effects.play()
		if points >= 3:
			var i = rnd.randi_range(0, 2)
			msg.texture = load("res://Images/WWD" + str(i) + ".png")
			get_node("Effects").stream = load("res://Audio/Voice/WWD" + str(i) + ".wav")
			get_node("Effects").play()
			
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

#Spawn either the snails - basically how much the user got correct
func spawnRes(i: int) -> void:
	var twn = get_tree().create_tween()
	var imgIns: TextureRect = TextureRect.new()
	add_child(imgIns)
	@warning_ignore("integer_division")
	var sz: float = (720 - (10 * 5)) / 4

	imgIns.texture = load("res://Images/QuizR" + str(iStory) + ".png")
	imgIns.expand = true
	imgIns.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	#Size and position of the spawned units
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
		var cnt = $Continue
		var ta = $TryAgain
		var twn = get_tree().create_tween()
		twn.tween_property(ta, "scale", Vector2(1, 1), 0.5) 
		twn.tween_property(cnt, "scale", Vector2(1, 1), 0.5)


func _on_safety_timer_timeout():
	var twn = get_tree().create_tween()
	var y = $qPlay/bYes
	var n = $qPlay/bNo
	
	twn.tween_property(y, "scale", Vector2(1,1), 0.4)
	twn.tween_property(n, "scale", Vector2(1,1), 0.4)

func _on_continue_button_down():
	get_parent().call("startGame")

func _on_try_again_button_down():
	get_parent().call("startQuiz")
