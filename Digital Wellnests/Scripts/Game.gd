extends TextureRect

@export var Conveyor: PackedScene
@export var Envelope: PackedScene
@export var Target: PackedScene
@export var Tile: PackedScene
@export var Activities: PackedScene
@export var Cat:PackedScene
@onready var catInstance = Cat.instantiate()

var _screenSize: Vector2
var speed: float
var goal: int
var score: int
var lives: int
var lay: Array [int]
var group: Array[int]
var level: int
var colCount: int
var gameOver: bool
var gameIndex: int
var bpaused: bool

var thread: Thread
var unitSize: float

var prevx: int
var prevy: int
var matches: int

var prev: Array
var grid: Array

var prevObj


func _ready():
	# Playing the voices for each game
	$Effects.stream = ResourceLoader.load("res://Audio/Voice/GameEx" + str(gameIndex) + ".wav")
	$Effects.play()
	bpaused = false

	# Loading the how to play instructions of each game
	$StartGame/HowTo.texture = ResourceLoader.load("res://Images/GameEx" + str(gameIndex) + ".png")
	grab_click_focus()

func _on_play_button_button_down():
	level = int($StartGame/HSlider.value)
	$Hud/Score2.show()
	$Pause.show()

	# Remove the instructions
	$StartGame.scale = Vector2(0.01, 0.01)
	startGame()

func startGame():
	# At the start, all games have 3 lives and to win you need to have 20 points
	# Initially it is 0
	goal = 20
	lives = 3
	score = 0 
	gameOver = false
	
	# Safety Snail game
	# This set up the initial state of the game, by creating belts for each level
	# and starts a time to spawn the envelopes
	if gameIndex == 0:
		#Displaying the 3 hearts
		$Hud/Lives.texture = ResourceLoader.load("res://Images/Heart3.png")
		
		# Calculate the conveyor size based on the level
		var conSize: int = (level + 1) / 2 + 5
		calcConveyor(conSize) 
		
		# Calculate the conveyor size based on the level
		speed = level * 0.2 + 1             # Calculate the speed based on the level
		_screenSize = get_viewport().size   # Set the screen size
		
		# Initialize variables for looping through the layout (lay)
		var items: int = lay.size()
		var posCount: int = 0
		var num: int = 0

		for j in range (items):
			num += lay[j]
			
		unitSize = _screenSize.x / num

		# Loop through the layout and create conveyors
		for i in range (items):
			createConveyor(Vector2(unitSize * posCount + (unitSize * lay[i] / 2), _screenSize.y / 2 - 2), lay[i], i)
			posCount += lay[i]

		$EnvelopeTimer.wait_time = (10 / 1) / 10 + 1
		$EnvelopeTimer.start()

	# Happy Hippo game
	elif gameIndex == 1:
		$Hud/Lives.texture = ResourceLoader.load("res://Images/Heart3.png") 

		$BullyTimer.wait_time = (18 - level) * 0.06
		$BullyTimer.start()
		prev = [[0, 0], [0, 0]]

	# Wolf, Hyena and Fox game
	elif gameIndex == 2:
		$Hud/Score2.hide()
		var x: int = 3
		var y: int = 2
		
		# Checks whether x is odd or is equals to y
		for i in range (1, (level + 1)/2):
			if x % 2 == 1 or x == y:
				x += 1
			else:
				y += 1

		for i in range(x):
			var row: Array = []
			for j in range(y):
				row.append(0)
			grid.append(row)
		
		spawnTiles(x,y)
		$Hud/Lives.hide()
		$Pause.hide()
	# Cyber Cat game
	elif gameIndex == 3:
		$Hud/Lives.texture = ResourceLoader.load("res://Images/Heart3.png") 
		$CatTimer.start()
		$ActivitiesTimer.start()


# Generate tiles 
func spawnTiles(maxx: int, maxy:int):
	var uneven: bool = false
	var imageA: int = 2
	var numImages: int =  maxx * maxy / 2
	var rand = RandomNumberGenerator.new()
	
	var tiles: Array = []
	for i in range(numImages):
		tiles.append([0,0])

	# Generates random numbers and check for duplicates, and populates the tiles accordingly
	for i in range(numImages):
		var rnd
		var fnd = false
		while true:
			fnd = false
			rnd = randf_range(0, 9)
			for j in range(i):
				if tiles[j][0] == rnd:
					fnd = true
			if !fnd:
				break
		tiles[i][0] = rnd
		if i == numImages-2 and uneven:
			tiles[i][1] = 2
		else:
			tiles[i][1] = imageA
	
	var val: int
	var scale = 4.5 / maxy
	var offy = int((480 - 100 * scale * maxy) / 2)
	var offx = int((720 - 100 * scale * maxx) / 2)
	
	if offx < 0:
		scale = 7.0 / maxx
		offx = int((720 - 100 * scale * maxx) / 2)
		offy = int((480 - 100 * scale * maxy) / 2)
	
	matches = maxx * maxy / 2
	
	for y in range (maxy):
		for x in range (maxx):
			var tileInstance = Tile.instantiate()
			add_child(tileInstance)
			var index

			index = randi() % numImages
			while tiles[index][1] <= 0:
				index = randi() % numImages
			
			tiles[index][1] -= 1
			val = tiles[index][0]
			
			grid[x][y] = val
			tileInstance.set("value", val)
			tileInstance.position = Vector2(x * 100 * scale + offx, y * 100 * scale + offy)
			tileInstance.scale = Vector2(scale, scale)

func tileClick(obj):
	if prevObj == null:
		prevObj = obj
	else:
		var ap = $Effects
		if prevObj.value != obj.value:
			prevObj.get_node("Timer").start()
			obj.get_node("Timer").start()
			ap.stream = load("res://Audio/Effects/aWrong.wav")
			ap.play()
		else:
			ap.stream = load("res://Audio/Effects/aRight2.wav")
			ap.play()
			matches -= 1
			prevObj.get_node("Tile").modulate = Color(0.7, 1, 0.6, 1)
			obj.get_node("Tile").modulate = Color(0.7, 1, 0.6, 1)
			if matches == 0:
				gameEnd(true)
		prevObj = null

# Generates a conveyor layout for the game, assigning different columns
func calcConveyor(conSize: int):
	var prev: int = -1               # Initialize previous group number
	var tmp: Array = []              # Temp array for conveyor sizes
	var conCount: int = level        # Initialize number of conveyor belt objects

	if conCount == 1:                # Ensure Conveyor count is atleast 2
		conCount += 1
	
	var size = (conSize) / conCount  # Calculate size of each conveyor belt object
	var random = RandomNumberGenerator.new()
	var containsAll: bool
	
	# Set the number of columns based on the current level
	if level <= 3:
		colCount = 2
	elif level <= 6:
		colCount = 3
	else:
		colCount = 4

	# Distribution of sizes of conveyor sections depending on the level
	if level == 1 or level == 10:
		lay = []
		for i in range(conCount):
			lay.append(int(size))
	elif level == 2:     # In level 2, there will be three conveyor sections with sizes 2, 3, and 2 respectively, the column count will be 3
		lay = [2, 3, 2]
		conCount = 3
	else:
	# Min and Max sizes of sections
		var minimum = 1
		var maximum = 3
		var k = 0
		conCount = 0
		var tot = 0
		
		# Generate the sizes of the conveyor belt objects
		while tot < conSize:
			if (conSize - tot < 3):
				tmp.append(conSize - tot)
				tot = conSize
			else:
				var rnd = random.randi_range(minimum, maximum)
				if rnd == 3:
					maximum -= 1
				tmp.append(rnd)
				tot += rnd
			k += 1
			conCount += 1
	
		#lay = []
		lay.resize(conCount)
		for i in range(conCount):
			lay.append(tmp[i])
			
		# Calculate conveyor group
		group = [conCount]
		while (!containsAll):
			containsAll = true
			for i in range(conCount):
				var rnd: int
				rnd = randi() % colCount
				while rnd == prev:
					rnd = randi() % colCount
				prev = rnd
				group.append(rnd)
				
			for j in range(colCount):
				if !group.find(j) != -1:
				#if !group.has(j):
					containsAll = false

func createConveyor(pos: Vector2, size: int, i:int):
	var convInstance = Conveyor.instantiate()
	$inGame.add_child(convInstance)
	
	var random = RandomNumberGenerator.new()
	convInstance.position = pos
	
	convInstance.frame = random.randi_range(0, 119)
	convInstance.speed_scale = 3.1 * speed
	convInstance.animation = "Move" + str(size)
	
	convInstance.scale = Vector2(unitSize / 100 * 1, convInstance.scale.y)

	if i < group.size():
		if group[i] == 0:
			# grayish color
			convInstance.modulate = Color(0.15, 0.15, 0.15, 1)
		elif group[i] == 2:
			# bluish color
			convInstance.modulate = Color(0.05, 0.3, 0.8, 1)
		elif group[i] == 3:
			# greenish color
			convInstance.modulate = Color(0.09, 0.62, 0.14, 1)
	convInstance.play()

func spawnEnvelope(type: int, lane: int):
	if !gameOver:
		var envInstance = Envelope.instantiate()
		$inGame.add_child(envInstance)
		
		envInstance.set("midPos", unitSize)
		envInstance.position = Vector2((lane + 1) * unitSize - unitSize / 2, -10)
		envInstance.scale *= Vector2(unitSize / 100, unitSize / 100)
		envInstance.set("Speed", 1.1 * speed)
		envInstance.set("lane", lane)
		envInstance.set("type", type)
		
		if type == 0:
			envInstance.modulate = Color(0.15, 0.15, 0.15, 1)
		elif type == 2:
			envInstance.modulate = Color(0.05, 0.3, 0.8, 1)
		elif type == 3:
			envInstance.modulate = Color(0.09, 0.62, 0.14, 1)

		var random = RandomNumberGenerator.new()
		envInstance.rotation_degrees = random.randi_range(0, 89) - 45

func updateScore(punt: bool):
	if not gameOver:
		$Hud/Score2.show()
		if punt:
			#print("Score++")
			score += 1
			$Hud/Score2.text = str(score) + " "
			if score >= goal:
				gameEnd(true)
		else:
			#print("Lives--")
			lives -= 1
			$Hud/Lives.texture = ResourceLoader.load("res://Images/Heart" + str(lives) + ".png")
			#$Hud/Lives.rect_min_size = Vector2(40 * lives, 35)
			if lives <= 0:
				gameEnd(false)

func _on_envelope_stop_area_entered(area):
	if gameIndex == 0:
		var tot = lay[0]
		var temp = area.get("lane")
		var convIndex = 0
		while temp >= tot:
			tot += lay[convIndex]
			convIndex += 1
		
		var ap = $Effects
		#Check if the entered area's type matches the conveyor's group
		if int(area.type) == group[convIndex]:
			ap.stream = ResourceLoader.load("res://Audio/Effects/aRight2.wav")
		else:
			ap.stream = ResourceLoader.load("res://Audio/Effects/aWrong.wav")
		ap.play()
		updateScore(int(area.get("type")) == group[convIndex])

		area.get_node("EnvelopeAnim").animation = "Shrink"
		area.get_node("EnvelopeAnim").play()

func gameEnd(win: bool):
	var ap = $Effects
	gameOver = true
	$CatTimer.stop()
	$BullyTimer.stop()
	$ActivitiesTimer.stop()

	var hud = $Hud
	if win:
		catInstance.queue_free()
		ap.stream = ResourceLoader.load("res://Audio/Effects/aWin.wav")
		$Hud/Message.text = "You WIN"
		$Hud/EndAnim.animation = "Victory" + str(gameIndex)
	else:
		catInstance.queue_free()
		ap.stream = ResourceLoader.load("res://Audio/Voice/TA.wav")
		$Hud/Message.text = "You LOSE"
		$Hud/EndAnim.animation = "Defeat" + str(gameIndex)
	ap.play()
	
	$Hud/EndAnim.visible = true
	$Hud/EndAnim.play()
	$Hud/Message.visible = true
	grab_click_focus()
	var control = $EndGame
	control.show()
	control.z_index = get_child_count() - 1


func _on_b_level_button_down():
	$Hud/EndAnim.visible = false
	$Hud/Message.visible = false

	get_parent().call("startGame")
	queue_free()

func _on_b_menu_button_down():
	$Hud/EndAnim.visible = false
	$Hud/Message.visible = false

	#get_parent().call("returnToMain")
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
	#var mainInstance = preload("res://Scenes/Main.tscn").instantiate()
	#var mainInstance = Main.instantiate() 
	#get_tree().root.add_child(mainInstance)
	queue_free()


func _on_h_slider_value_changed(value):
	$StartGame/LevelIndicator.text = "Level " + str(value)

func _on_envelope_timer_timeout():
	thread = Thread.new()
	#thread.start(_thread_function)
	var random = RandomNumberGenerator.new()
	var tp = random.randi_range(0, colCount - 1)
	var ln = random.randi() % ((level + 1) / 2 + 5)
	spawnEnvelope(tp, ln)
	#thread.start(_thread_function.bind("dummy"))

	
#func _thread_function(dummy):
#	var random = RandomNumberGenerator.new()
#	var tp = random.randi() % colCount
#	var ln = random.randi() % ((level + 1) / 2 + 5)
#	spawnEnvelope(tp, ln)


func _on_bully_timer_timeout():
	var targetInstance = Target.instantiate()
	
	add_child(targetInstance)
	var scale = 0.04 * (20 - level)

	targetInstance.scale = Vector2(scale, scale)
	
	var rand = RandomNumberGenerator.new()
	
	targetInstance.get_node("DispTimer").wait_time = (16 - level) / 4
	targetInstance.get_node("DispTimer").start()
	
	var x: int
	var y: int
	var uni: bool
	#uni = false
	
	while true:
		uni = true
		x = randi() % (720 - int(scale * 400)) + int(scale * 200)
		y = randi() % (480 - int(scale * 300)) + int(scale * 150)
		
		for i in range(2):
			if (pow(x - prev[i][0], 2) + pow(y - prev[i][1], 2) < pow(200, 2)):
				uni = false
		if uni:
			break

	prev[1][0] = prev[0][0]
	prev[1][1] = prev[0][1]
	
	prev[0][0] = x
	prev[0][1] = y

	var pos = Vector2(x, y)
	targetInstance.position = pos
	
	if randi() % 4 == 3:
		targetInstance.set("bully", false)
		targetInstance.get_node("TargetFace").animation = "Victim"
	else:
		targetInstance.set("bully", true)
		targetInstance.get_node("TargetFace").animation = "Bully"


func calcHit(bully: bool):
	updateScore(bully)


func pauseG():
	bpaused = true
	var ig = get_node("inGame") 

	if gameIndex == 0:
		$EnvelopeTimer.paused = true

		for env in ig.get_children():
			if env == Envelope:
				env.speed = 0
				env.hit = true
			elif env == AnimatedSprite2D:
				env.stop()

	elif gameIndex == 1:
		get_node("BullyTimer").paused = true

		for tar in ig.get_children():
			if tar == Target:
				tar.get_node("TargetTimer").paused = true
				tar.get_node("DispTimer").paused = true
	elif gameIndex == 3:
		$ActivitiesTimer.paused = true
		GD.isNotAllowed = false
		for act in ig.get_children():
			if act == Activities:
				act.get_node("ActivitiesTimer").paused = true

func playG():
	bpaused = false
	var ig = get_node("inGame") as Control

	if gameIndex == 0:
		get_node("EnvelopeTimer").paused = false

		for env in ig.get_children():
			if env == Envelope:
				env.speed = 1.1 * speed
				env.hit = false
			elif env is AnimatedSprite2D:
				env.play()

	elif gameIndex == 1:
		get_node("BullyTimer").paused = false

		for tar in ig.get_children():
			if tar == Target:
				tar.get_node("TargetTimer").paused = false
				tar.get_node("DispTimer").paused = false

	elif gameIndex == 3:
		$ActivitiesTimer.paused = false
		GD.isNotAllowed = true
		for act in ig.get_children():
			if act == Activities:
				act.get_node("ActivitiesTimer").paused = false

func _on_pause_button_down():
	if bpaused:
		playG()
	else:
		pauseG()


func _on_pause_pressed():
	if bpaused:
		playG()
	else:
		pauseG()


func _on_activities_timer_timeout():
	var actInstance = Activities.instantiate()
	var actLocation = $Path2D/PathFollow2D
	actLocation.progress_ratio = randf()
	
	var direction = PI / 2
	actInstance.position = actLocation.position

	#var velocity = Vector2(randf_range(100.0, 250.0) + (level * 20.0), 0.0)
	var speed = randf_range(50, 150.0)

	if level <= 3:
		speed += level * 30.0
	elif level <= 6:
		speed += level * 40.0
	else:
		speed += level * 55.0

	var velocity = Vector2(speed, 0.0)
	actInstance.linear_velocity = velocity.rotated(direction)

	add_child(actInstance)

	if randi() % 4 == 3:
		actInstance.set("Monster", false)
		actInstance.get_node("ActivitiesAnim").animation = "Monster"
		actInstance.get_node("ActivitiesAnim").scale = Vector2(0.45,0.45)
	else:
		actInstance.set("coin", true)
		actInstance.get_node("ActivitiesAnim").animation = "Coin"


func calculateHit(coin: bool):
	updateScore(coin)

func _on_cat_timer_timeout():
	add_child(catInstance)
