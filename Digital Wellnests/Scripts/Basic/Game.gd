extends Control

# Exported variables for different scene references, enabling them to be set in the Inspector node
@export var Conveyor: PackedScene
@export var Envelope: PackedScene
@export var Target: PackedScene
@export var Tile: PackedScene
@export var Activities: PackedScene
@export var Cat:PackedScene
@export var Mails:PackedScene

# Preloading the obstacles scene for quick access
@export var Cactus: PackedScene
@export var Cacti: PackedScene
@export var Thorn: PackedScene
@export var Ball: PackedScene
@export var Bird: PackedScene
@export var Coin: PackedScene

# Ready variables for nodes and scenes
@onready var pauseMenu = $PauseGame/PauseG
@onready var catInstance = Cat.instantiate()

# Constants for Elephant and his shoe game
# Start position of the character and the camera, based on placement
const RABBIT_START_POS = Vector2i(30, 339)
const CAM_START_POS = Vector2i(360, 240)

# Initial and maxium speed
const START_SPEED : float = 7.0
const MAX_SPEED : int = 20

var _screenSize: Vector2
var screen_size : Vector2i
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
var bpaused: bool = false
var paused: bool

var thread: Thread
var unitSize: float

var prevx: int
var prevy: int
var matches: int

var prev: Array
var grid: Array

var prevObj

var groundHeight: int
var rabbitSpeed : float

# List of possible obstacle scenes, more can be added
#var obstaclesType := [cactusScene, cactiScene, thornScene, ballScene, coinScene]

var obstaclesType: Array[PackedScene] = []
# Array for storing instantiated obstacles
var obstacles: Array = []

# Last obstacle spawned
var lastObs

# Height of the bird and score
var birdHeight := [240, 390]
var coinHeight: = [170, 370]
var rabbitScore

func _ready():
	# Playing the voices for each game
	$Effects.stream = ResourceLoader.load("res://Audio/Voice/GameEx" + str(gameIndex) + ".wav")
	$Effects.play()
	bpaused = false

	# Loading the how to play instructions of each game
	$StartGame/HowTo.texture = ResourceLoader.load("res://Images/GameEx" + str(gameIndex) + ".png")

	# Ensures that the game window responds to player inputs
	grab_click_focus()

	# Enable viewport for the camera to follow the screen, can be done in the Inspector node
	#$CanvasLayer.follow_viewport_enabled = true
	# Initialize the obstacle types array
	obstaclesType = [Cactus, Cacti, Thorn, Ball, Coin]

	# Screensize of the window, this is used for resising elements based on the screen resolution
	screen_size = get_viewport().get_visible_rect().size
	#screen_size = get_window().size

	# If gameIndex == 2, which is Elephant and his shoe, disable the already existing collision shape
	# So that it does not intefer with other games
	if gameIndex == 2:
		# Get the height of the ground sprite, this is used for positioning objects in the game
		Engine.max_fps = 60
		$Hud.follow_viewport_enabled = false
		groundHeight = $GameNode2D/Ground.get_node("Sprite2D").texture.get_height()
		$GameNode2D/Ground.get_node("CollisionShape2D").set_disabled(false)
		$GameNode2D/Rabbit.get_node("CanvasLayer/TextureButton").visible = true
	else:
		if $GameNode2D and $GameNode2D/Ground:
			$GameNode2D/Ground.get_node("CollisionShape2D").set_disabled(true)
		if $GameNode2D and $GameNode2D/Rabbit:
			$GameNode2D/Rabbit.get_node("CanvasLayer/TextureButton").visible = false
			groundHeight = 100
	# Call the running function
	startRunning()

func _process(delta: float) -> void:
	# Check if the game is paused
	if bpaused:
		return
		
	if gameIndex == 2:
		generateObstacles()

		# Move the character2d and camera
		$GameNode2D/Rabbit.position.x += rabbitSpeed
		$GameNode2D/Camera2D.position.x += rabbitSpeed

		# Update score based on the distance
		rabbitScore += rabbitSpeed
		
		#var screen_size = get_viewport().size
		#var groundWidth = $GameNode2D/Ground.get_node("Sprite2D").texture.get_width() * $GameNode2D/Ground.scale.x
		# Update the ground position when the ground position ends
		if $GameNode2D/Camera2D.position.x - $GameNode2D/Ground.position.x > screen_size.x * 1.5:
			$GameNode2D/Ground.position.x += screen_size.x
		#if $GameNode2D/Camera2D.position.x - $GameNode2D/Ground.position.x > groundWidth:
			#$GameNode2D/Ground.position.x += groundWidth
		#print("Is Ground visible?: ", $GameNode2D/Ground.visible)

		# Remove obstacles that already have passed
		# Create a temporary array for obstacles to remove
		var obstaclesToRemove = []

		for obs in obstacles:
			# Check if the obstacle is valid and has moved out of the screen's view
			if is_instance_valid(obs) and obs.position.x < ($GameNode2D/Camera2D.position.x - screen_size.x):
				obstaclesToRemove.append(obs)

		# Remove obstacles after the loop
		for obs in obstaclesToRemove:
			removeObstacle(obs)

func _on_play_button_pressed():
	level = int($StartGame/HSlider.value)
	$Hud/Score.show()
	$PauseGame/Pause.show()
	Music.clickSfx()

	# Remove the instructions
	$StartGame.scale = Vector2(0, 0)
	$GameNode2D/Rabbit.setActive(true)
	if gameIndex == 2:
		bpaused = false
	$Effects.stop()
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
		_screenSize = Vector2(720, 480)     # Set the screen size

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

	elif gameIndex == 1:
		$Hud/Lives.texture = ResourceLoader.load("res://Images/Heart3.png")
		$MailTimer.start()

	elif gameIndex == 2:
		#$".".scale = Vector2(1,1)
		$StartGame.scale = Vector2(1,1)
		$GameNode2D.scale = Vector2(1,1)
		$BG.hide()
		
		$StartGame.hide()
		
		$Hud/Lives.texture = ResourceLoader.load("res://Images/Heart3.png")
		$GameNode2D/Background.show()
		$GameNode2D/Ground.show()
		$GameNode2D/Rabbit.show()
		$GameNode2D/Rabbit.setActive(true)
		$GameNode2D/Camera2D.make_current()

		# Ajust the speed slowly, based on each level
		# 5 + ((1-1)/ (10-1) * (15 - 5) * 0.5
		rabbitSpeed = START_SPEED + ((level - 1) / float($StartGame/HSlider.max_value - 1)) * (MAX_SPEED - START_SPEED) * 0.3
		if level >= 7:
			rabbitSpeed = START_SPEED * 1.5

		# Limit the speed to the max speed allowed
		if rabbitSpeed > MAX_SPEED:
			rabbitSpeed = MAX_SPEED

		bpaused = false

	# Wolf, Hyena and Fox game
	elif gameIndex == 3:
		$Hud/Score.hide()
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
		$PauseGame/Pause.show()

	# Happy Hippo game
	elif gameIndex == 4:
		$Hud/Lives.texture = ResourceLoader.load("res://Images/Heart3.png")

		$BullyTimer.wait_time = (18 - level) * 0.06
		$BullyTimer.start()
		prev = [[0, 0], [0, 0]]

	# Cyber Cat game
	elif gameIndex == 5:
		$Hud/Lives.texture = ResourceLoader.load("res://Images/Heart3.png")
		$CatTimer.start()
		$ActivitiesTimer.start()

# Elephant and his shoe game
func startRunning():
	rabbitScore = 0
	$GameNode2D/Rabbit.position = RABBIT_START_POS
	$GameNode2D/Rabbit.velocity = Vector2i(0, 0)
	$GameNode2D/Camera2D.position = CAM_START_POS
	$GameNode2D/Ground.position = Vector2i(0, 0)

	bpaused = true

func generateObstacles():
	# If its game over
	if gameOver:
		return

	# If the obstacles array/list is empty
	# Or if the last obstacle is far from the Rabbit's current score
	if obstacles.is_empty() or !is_instance_valid(lastObs) or lastObs.position.x < rabbitScore + randi_range(100, 150):
		# Maximum number of obstacles
		var maxObstacles = 1
		# If the level is greater than 3, start generating a maximum of 2 obstacles
		# Adding more challenge to the game
		var obstaclesType := [Cactus, Cacti, Thorn, Ball, Coin]
		if level > 6:
			obstaclesType += [Ball, Coin]
		#if level > 7:
			#maxObstacles = 2
		#if level > 7:
			#maxObstacles = 3
		
		#print("Screen size: ", screen_size)
		
		# Store already used positions to prevent overlap
		var usedPositions = []
		
		# Minimum spacing between obstacles (horizontal)
		var minSpacing = 300
		
		# Get viewport size for proper positioning
		var viewport_size = get_viewport().get_visible_rect().size
		# Generate the specified number of obstacles
		for i in range(maxObstacles):
			# Pick a different obstacle type each iteration
			var obsType = obstaclesType[randi() % obstaclesType.size()]
			var obs = obsType.instantiate()

			# Get height and scale information
			var obsHeight = obs.get_node("Sprite2D").texture.get_height()
			var obsScale = obs.get_node("Sprite2D").scale

			#var obs_x: int = screen_size.x + rabbitScore + 100 + (i * 100)
			# Calculate base position with increased spacing between obstacles
			var obs_x = screen_size.x + rabbitScore + 100 + (i * minSpacing)
			# Set position of each obstacle
			if level >= 6:
				#obs_x = screen_size.x + rabbitScore + 100 + (i * 250)
				obs_x = screen_size.x + rabbitScore + 100 + (i * (minSpacing + 150))
				
			obs_x += randi_range(0, 50)	
			# Calculate ground level position - use viewport height instead of screen_size
			var viewport_height = get_viewport().get_visible_rect().size.y
			
			#var obs_y: int = screen_size.y - groundHeight - (obsHeight * obsScale.y / 2) + 168

			# Calculate Y position with adjusted values for web
			var ground_level = viewport_height - 50 # Approximate ground level
			var obs_y = ground_level - (obsHeight * obsScale.y / 2)
			
			# Increase the y-axis of the ball to be a bit higher
			if obsType == Ball:
				obs_y -= 19
			if obsType == Coin:
				# Position coinScene in the middle to top of the screen
				#obs_y = randi_range(int(screen_size.y * 0.3), int(screen_size.y * 0.7))
				obs_y = randi_range(int(viewport_height * 0.3), int(viewport_height * 0.7))

			# Check if this position is too close to any existing obstacle
			var validPosition = true
			for pos in usedPositions:
				# Check for horizontal and vertical overlap
				if abs(pos.x - obs_x) < minSpacing and abs(pos.y - obs_y) < 50:
					validPosition = false
					break
			# If position invalid, adjust y position to avoid overlap
			if not validPosition and obsType != Coin:
				obs_y -= 50  # Move obstacle up to avoid overlap
			
			# Record position and add obstacle
			usedPositions.append(Vector2(obs_x, obs_y))
			obs.position = Vector2(obs_x, obs_y)

			# Update lastObs and add obstacle to the scene
			lastObs = obs
			#print("Last Obstacle: ", obs_x)
			addObstacles(obs, obs_x, obs_y,obsType)

		if level >= 5 and (randi() % 2) == 0:
			# Generate a bird obstacle
			var birdObs = Bird.instantiate()
			var obs_x: int = screen_size.x + rabbitScore + 100
				
			#var obs_y : int = birdHeight[randi() % birdHeight.size()] - 130
			var viewport_height = get_viewport().get_visible_rect().size.y
			var bird_height_options = [viewport_height * 0.1, viewport_height * 0.3]
			var obs_y = bird_height_options[randi() % bird_height_options.size()]
			#print("obs_y: ", obs_y)
			addObstacles(birdObs, obs_x, obs_y, Bird)

func losePoints(body):
	# Check if the colliding body is the Rabbit
	if body.name == "Rabbit":
		var audio = $Effects

		# Make the player blink twice when it collides with harmful obstacles
		for i in range(2):
			body.visible = false
			await get_tree().create_timer(0.1).timeout
			body.visible = true
			await get_tree().create_timer(0.1).timeout
		audio.stream = load("res://Audio/Effects/aWrong.wav")
		audio.volume_db = -3.0
		audio.play()
		$GameNode2D/Rabbit.stopJumpingSound()
		$GameNode2D/Rabbit.makeInvisible()
		updateScore(false)

func gainPoints(body):
	# Check if the colliding body is the Rabbit
	if body.name == "Rabbit":
		var audio = $Effects
		audio.stream = load("res://Audio/Effects/aRight2.wav")
		audio.play()

		$GameNode2D/Rabbit.stopJumpingSound()
		$GameNode2D/Rabbit.makeInvisible()
		updateScore(true)

func addObstacles(obs, x, y, obsType):
	# Position of the obstacles
	obs.position = Vector2(x, y)
	# Connect obstacle collision signals based on the type of obstacle
	if obsType == Ball:
		obs.body_entered.connect(gainPoints)
	elif obsType == Coin:
		obs.body_entered.connect(gainPoints)
	else:
		obs.add_to_group("bird")
		obs.body_entered.connect(losePoints)
	# Making the obstacles appear in front of other objects
	obs.z_index = 1

	#if obs.has_method("set_z_as_relative"):
		#obs.set_z_as_relative(false)
	#print("Obstacle z_index: ", obs.z_index)
	#print("Rabbit z_index: ", $CanvasLayer/Rabbit.z_index)

	# Adding the obstacles to the scene tree, otherwise, add directly to the current node
	if true:
		get_parent().add_child(obs)
	else:
		add_child(obs)
	#print("Added obstacle at position: ", Vector2(x, y))
	#print("Added obstacle: ", obs.name)
	# Keep adding obstacles in the obstacles array
	obstacles.append(obs)

func removeObstacle(obs):
	# Remove the obstacle from the obstacles array first
	if obstacles.has(obs):
		obstacles.erase(obs)

	# Then remove it from the scene
	obs.queue_free()

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

# Random shuffle of the colors
func customShuffle(arr: Array) -> Array:
	var n = arr.size()
	for i in range(n - 1, 0, -1):
		var j = randi() % (i + 1)
		arr[i] = arr[i] ^ arr[j]
		arr[j] = arr[i] ^ arr[j]
		arr[i] = arr[i] ^ arr[j]
	return arr

# Generates a conveyor layout for the game, assigning different columns
func calcConveyor(conveyorSize: int):
	var prev: int = -1               # Initialize previous group number
	var tmp: Array [int] = []        # Temp array for conveyor sizes
	var conCount = level             # Initialize number of conveyor belt objects

	if conCount == 1:
		conCount += 1                # Ensure there is at least one conveyor belt object

	# Calculate size of each conveyor belt object
	var size: float = (conveyorSize) / conCount
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
	if level == 1:
		lay = [2, 2]
		group = [0,1]
		group = customShuffle(group)
		if group[0] == group[1]:
			group[1] = (group[1] + 1) % colCount

	# In level 2, there will be three conveyor sections with sizes 2, 3, and 2 respectively, the column count will be 3
	elif level == 2:
		lay = [2, 3, 2]
		group = [1, 0, 1]
		group = customShuffle(group)
	else:
		# Min and Max sizes for determining the sizes of conveyor sections
		var minimum = 1
		var maximum = 3
		# For keeping track of the index when populating the tmp array
		var k = 0
		# Determine the total number of conveyor sections
		conCount = 0
		# Total size of conveyor sections generated
		var tot = 0

		# Generate the sizes of the conveyor belt objects with a size that is in between 1 and 3.
		# While the total size is less than the conveyor size
		while tot < conveyorSize:
		# Check whether the remaining size is less than 3, if so set the remaining size and add it to the temp array.
			if (conveyorSize - tot < 3):
				tmp.append(conveyorSize - tot)
				tot = conveyorSize
			else:
			# if the size is 3 or more, excecute the following
			# Generate a number between 1 and 3, if the number is 3, decrement max by 1 and update the temp array.
				var rnd = random.randi_range(minimum, maximum)
				if rnd == 3:
					maximum -= 1
				tmp.append(rnd)
				tot += rnd
			# Increment the counters for index and conveyor sections to keep track of the generated conveyors
			k += 1
			conCount += 1

		# Create a new array called 'lay'
		lay = []
		# Fill in the temporary array with the conveyorCount
		for i in range(conCount):
			lay.append(tmp[i])

		var conveyorIndices: Array = []
		for i in range(conCount):
			conveyorIndices.append(i + 1)

		# Calculate conveyor group
		# Initialises a new array with a size of conveyor count
		while (!containsAll):
			containsAll = true
			group.clear()
			# Array to store unique colors
			var uniqueColors: Array = []

			for i in range(conCount):
				var rnd: int
				rnd = randi() % colCount
				while rnd == prev:
					rnd = randi() % colCount
				prev = rnd
				group.append(rnd)

			for colorIndex in range(colCount):
				var foundColor = false
				for j in range(conCount):
					if group[j] == colorIndex:
						foundColor = true
						break
				if not foundColor:
					containsAll = false
					break

func createConveyor(pos: Vector2, size: int, i:int):
	var convInstance = Conveyor.instantiate()
	$BG/inGame.add_child(convInstance)

	var random = RandomNumberGenerator.new()
	convInstance.position = pos

	convInstance.frame = random.randi_range(0, 119)
	convInstance.speed_scale = 3.1 * speed
	convInstance.animation = "Move" + str(size)

	convInstance.scale = Vector2(unitSize / 100 * 1, convInstance.scale.y)

	if i < group.size():
		if group[i] == 0:
			# Pinkish
			convInstance.modulate = Color(1.0, 1.0, 1.0, 1)
			# Greyish
		elif group[i] == 1:
			convInstance.modulate = Color(0.15, 0.15, 0.15, 1)
			# Blueish
		elif group[i] == 2:
			convInstance.modulate = Color(0.05, 0.3, 0.8, 1)
			# Greenish
		elif group[i] == 3:
			convInstance.modulate = Color(0.09, 0.62, 0.14, 1)
	convInstance.play()

func spawnEnvelope(type: int, lane: int):
	if !gameOver:
		var envInstance = Envelope.instantiate()
		$BG/inGame.add_child(envInstance)

		envInstance.set("midPos", unitSize)
		envInstance.position = Vector2((lane + 1) * unitSize - unitSize / 2, -10)
		envInstance.scale *= Vector2(unitSize / 100, unitSize / 100)
		envInstance.set("Speed", 1.1 * speed)
		envInstance.set("lane", lane)
		envInstance.set("type", type)

		# Scale the envelope in level 1
		if level == 1:
			envInstance.scale *= Vector2(0.7, 0.7)

		if type == 0:
			envInstance.modulate = Color(1.0, 1.0, 1.0, 1)
		elif type == 1:
			envInstance.modulate = Color(0.15, 0.15, 0.15, 1)
		elif type == 2:
			envInstance.modulate = Color(0.05, 0.3, 0.8, 1)
		elif type == 3:
			envInstance.modulate = Color(0.09, 0.62, 0.14, 1)

		var random = RandomNumberGenerator.new()
		envInstance.rotation_degrees = random.randi_range(0, 89) - 45

func updateScore(punt: bool):
	if not gameOver:
		$Hud/Score.show()
		if punt:
			score += 1
			$Hud/Score.text = str(score) + " "
			if score >= goal:
				gameEnd(true)
		else:
			lives -= 1
			$Hud/Lives.texture = ResourceLoader.load("res://Images/Heart" + str(lives) + ".png")
			if lives <= 0:
				gameEnd(false)

func _on_envelope_stop_area_entered(area):
	if gameIndex == 0:
		# Total of conveyor sizes, it is initialised with the size of the first conveyor
		var tot = lay[0]
		# Holds the temporary lane of the current envelope
		var temp: int = area.get("lane")
		# Keeps track of the conveyor being checked at the moment
		var convIndex: int = 0
		# When the temp position exceeds the total of conveyor sizes it will be incremented
		while temp >= tot:
			tot += lay[convIndex+1]
			convIndex += 1

		var ap = $Effects
		# Check if the entered area's type matches the conveyor's group
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
	var mailInstance = Mails.instantiate()
	speed = -10.0
	mailInstance.setSpeed(speed)

	$MailTimer.stop()
	$CatTimer.stop()
	$BullyTimer.stop()
	$ActivitiesTimer.stop()

	if gameIndex == 2:
		# Checks if camera2D exists in canvaslayer
		if $GameNode2D/Camera2D:
			# Ensures this camera is active
			$GameNode2D/Camera2D.make_current()
			# Stop any processing in Camera2D,
			$GameNode2D/Camera2D.set_process(false)
			# Disable Camera2D to stop it from following
			$GameNode2D/Camera2D.enabled = false

	# gameIndex == 3
	# Stop generating new obstacles and clear the list
		var valid_obstacles = obstacles.filter(func(obs): return is_instance_valid(obs))
		for obs in valid_obstacles:
			obs.queue_free()
		obstacles.clear()

		#$CanvasLayer.follow_viewport_enabled = false
	#if gameIndex == 1:
		$".".scale = Vector2(1,1)
		$EndGame.show()

	var hud = $Hud
	if win:
		catInstance.queue_free()
		mailInstance.queue_free()

		ap.stream = ResourceLoader.load("res://Audio/Effects/aWin.wav")
		$Hud/Message.text = "You WIN"
		$Hud/EndAnim.animation = "Victory" + str(gameIndex)
	else:
		catInstance.queue_free()
		mailInstance.queue_free()
		ap.stream = ResourceLoader.load("res://Audio/Voice/TA.wav")
		$Hud/Message.text = "You LOSE"
		$Hud/EndAnim.animation = "Defeat" + str(gameIndex)
	$PauseGame/Pause.hide()
	ap.play()

	$Hud/EndAnim.visible = true
	$Hud/EndAnim.play()
	$Hud/Message.visible = true
	grab_click_focus()
	var control = $EndGame
	control.show()
	#control.z_index = get_child_count() - 1

func _on_b_level_button_down():
	$Hud/EndAnim.visible = false
	$Hud/Message.visible = false
	Music.clickSfx()

	get_parent().call("startGame")
	queue_free()

func _on_b_menu_button_down():
	$Hud/EndAnim.visible = false
	$Hud/Message.visible = false
	Music.clickSfx()
	
	# Returning back to Main Menu
	var mainInstance = get_parent()
	mainInstance.returnToMain()

	#get_tree().change_scene_to_file("res://Scenes/Main.tscn")
	queue_free()

func _on_h_slider_value_changed(value):
	var level = int(value)
	$StartGame/LevelIndicator.text = "Level " + str(level)

func _on_envelope_timer_timeout():
	var random = RandomNumberGenerator.new()
	var tp = random.randi_range(0, colCount - 1)
	var ln = random.randi() % ((level + 1) / 2 + 5)
	spawnEnvelope(tp, ln)

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

func pauseGame():
	bpaused = true
	var ig = $inGame

	if gameIndex == 0:
		get_tree().root.content_scale_size
		$EnvelopeTimer.paused = true
		for env in ig.get_children():
			# Check if the child node is of type Envelope
			if env.name == "Envelope":
				env.Speed = 0.0
				env.hit = true
			elif env == AnimatedSprite2D:
				env.stop()

	elif gameIndex == 1:
		$MailTimer.paused = true

	elif gameIndex == 4:
		get_node("BullyTimer").paused = true
		for tar in ig.get_children():
			if tar == Target:
				tar.get_node("TargetTimer").paused = true
				tar.get_node("DispTimer").paused = true

	elif gameIndex == 5:
		$ActivitiesTimer.paused = true
		GD.isNotAllowed = false
		for act in ig.get_children():
			if act.name == "Activities":
				act.get_node("ActivitiesTimer").paused = true

func playGame():
	# Play the game, unpause it
	bpaused = false
	var ig = $inGame

	# Play Safety Snail's Email game
	if gameIndex == 0:
		# Pause the envelope timer initially
		$EnvelopeTimer.paused = true

		# Iterate through all child nodes of the in-game node
		for env in ig.get_children():
			# Check if the child node is an envelope
			if env.name == "Envelope":
				# Set the speed of the envelope based on the game speed
				env.Speed = 1.1 * speed
				# Reset the hit status of the envelope
				env.hit = false
				# If the child node is an AnimatedSprite2D, play its animation
			elif env is AnimatedSprite2D:
				env.play()
		# Resume the envelope timer after setting up the envelopes and animations
		$EnvelopeTimer.paused = false

	# Play Lucky the Fish game
	elif gameIndex == 1:
		$MailTimer.paused = false

	elif gameIndex == 4:
		$BullyTimer.paused = false

		for tar in ig.get_children():
			if tar == Target:
				tar.get_node("TargetTimer").paused = false
				tar.get_node("DispTimer").paused = false

	elif gameIndex == 5:
		$ActivitiesTimer.paused = false
		GD.isNotAllowed = true
		for act in ig.get_children():
			if act == Activities:
				act.get_node("ActivitiesTimer").paused = false

func _on_activities_timer_timeout():
	var actInstance = Activities.instantiate()
	var actLocation = $CatPath2D/PathFollow2D
	actLocation.progress_ratio = randf()

	var direction = PI / 2
	actInstance.position = actLocation.position

	speed = randf_range(50, 150.0)

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

func mailScore(spamEmail: bool):
	updateScore(spamEmail)

func _on_cat_timer_timeout():
	add_child(catInstance)

func _on_pause_pressed() -> void:
	# Pause Mechanisms
	pauseMenu.pauseAnimation()
	# Only handle pause for specific game types (0,1,2,4,5)
	#if gameIndex:
	pauseMenus()

# Spawning the Mails randomly
func spawnMails():
	if gameIndex == 1:
		var mailInstance = Mails.instantiate()

		# Random value for the mails to spawn  on Path2D
		var mailLocation = %PathFollow2D
		mailLocation.progress_ratio = randf_range(0, 0.3)

		# Position to move the mails
		mailInstance.position = mailLocation.position

		add_child(mailInstance)
		if level == 1:
			speed = randf_range(150.0, 200.0)
			mailInstance.get_node("ItemsAnim").scale = Vector2(1,1)
			if randi() % 2 == 0:
				mailInstance.set("spamEmail", false)
				mailInstance.get_node("ItemsAnim").animation = "spamEmail"
				mailInstance.get_node("ItemsAnim").scale = Vector2(0.2,0.2)
			else:
				mailInstance.set("spamEmail", true)
				mailInstance.get_node("ItemsAnim").animation = "safeEmail"
				mailInstance.get_node("ItemsAnim").scale = Vector2(0.2,0.2)
		elif level == 2:
			speed = randf_range(200.0, 250.0)
			if randi() % 3 == 0:
				mailInstance.set("spamEmail", false)
				mailInstance.get_node("ItemsAnim").animation = "spamEmail"
				mailInstance.get_node("ItemsAnim").scale = Vector2(0.19,0.19)
			elif  randi() % 3 == 1:
				mailInstance.set("spamEmail", true)
				mailInstance.get_node("ItemsAnim").animation = "safeEmail"
				mailInstance.get_node("ItemsAnim").scale = Vector2(0.19,0.19)
			else:
				mailInstance.set("spamEmail", true)
				mailInstance.get_node("ItemsAnim").animation = "safeLink"
				mailInstance.get_node("ItemsAnim").scale = Vector2(0.19,0.19)
		elif level == 3:
			speed = randf_range(230.0, 280.0)
			if randi() % 3 == 0:
				mailInstance.set("spamEmail", false)
				mailInstance.get_node("ItemsAnim").animation = "spamEmail"
				mailInstance.get_node("ItemsAnim").scale = Vector2(0.18,0.18)
			elif  randi() % 3 == 1:
				mailInstance.set("spamEmail", true)
				mailInstance.get_node("ItemsAnim").animation = "safeEmail"
				mailInstance.get_node("ItemsAnim").scale = Vector2(0.18,0.18)
			else:
				mailInstance.set("spamEmail", false)
				mailInstance.get_node("ItemsAnim").animation = "spamLink"
				mailInstance.get_node("ItemsAnim").scale = Vector2(0.18,0.18)
		elif level >= 4:
			speed = randf_range(260.0, 310.0)
			if randi() % 4 == 0:
				mailInstance.set("spamEmail", false)
				mailInstance.get_node("ItemsAnim").animation = "spamEmail"
				mailInstance.get_node("ItemsAnim").scale = Vector2(0.17,0.17)
			elif  randi() % 4 == 1:
				mailInstance.set("spamEmail", true)
				mailInstance.get_node("ItemsAnim").animation = "safeEmail"
				mailInstance.get_node("ItemsAnim").scale = Vector2(0.17,0.17)
			elif randi() % 4 == 2:
				mailInstance.set("spamEmail", false)
				mailInstance.get_node("ItemsAnim").animation = "spamLink"
				mailInstance.get_node("ItemsAnim").scale = Vector2(0.17,0.17)
			else:
				mailInstance.set("spamEmail", true)
				mailInstance.get_node("ItemsAnim").animation = "safeLink"
				mailInstance.get_node("ItemsAnim").scale = Vector2(0.17,0.17)
		mailInstance.setSpeed(speed)

func _on_mail_timer_timeout():
	spawnMails()

func pauseMenus():
	# If the game is currently paused, unpause it
	if paused:
		pauseMenu.hide()
		get_tree().paused = false

		if gameIndex == 2:
			$GameNode2D/Rabbit.setActive(true)
			$GameNode2D/Rabbit.makeVisible()
			# Show the ground and rabbit again when unpausing
			$GameNode2D/Ground.show()
			$GameNode2D/Rabbit.show()
	else:
		pauseMenu.show()
		get_tree().paused = true

		if gameIndex == 2:
			$GameNode2D/Rabbit.setActive(false)
			$GameNode2D/Rabbit.makeInvisible()
			# Hide the ground and rabbit when pausing
			$GameNode2D/Ground.hide()
			$GameNode2D/Rabbit.hide()

	paused = !paused
