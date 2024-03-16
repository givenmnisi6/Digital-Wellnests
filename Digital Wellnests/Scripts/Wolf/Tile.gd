extends Area2D
class_name Tile

# Boolean to track whether the tile has been tapped
var tapped: bool
# Boolean to track whether the tile has been found
var found: bool
# Value associated with the tile
var value: int

func _ready():
	# Initialize found status to false
	found = false
	# Set initial animation for the image
	$Image.animation = "T-1"
	# Initialize value to 0
	value = 0 
	# Initialize tapped status to false
	tapped = false

# Called when the tile animation finishes
func _on_tile_animation_finished():
	# Stop the tile animation and reset frame
	$Tile.stop()
	$Tile.frame = 0
	
	# Check if the tile was tapped
	if not tapped:
		# Set animation to default if not tapped
		$Image.animation = "T-1"
	else:
		# Set animation based on tile value if tapped
		$Image.animation = "T" + str(value)

# Function to reset the tile
func reset():
	# Reset image animation
	$Image.animation = "T-1"
	# Reset tapped status
	tapped = false
	# Reset tile frame
	$Tile.frame = 0
	# Play flip animation
	$Tile.play("Flip", true)

# Called when the timer times out
func _on_timer_timeout():
	# Reset the tile
	reset()

# Called when input is received on the tile button
func _on_button_gui_input(event):
	if event is InputEventMouseButton and InputEventScreenTouch:
		# Check if the button is pressed and the tile is not tapped
		if event.pressed and !tapped:
			# Play tile animation
			$Tile.play()
			# Set tapped status to true
			tapped = true
			# Call tileClick function on the parent node
			get_parent().call("tileClick", self)
