extends Area2D

# Variables to track if the cat is hit and if it's being held
var hit: bool
var hold: bool

# Vector to store the screen size
var _screenSize: Vector2

# Variable to store the mid position
var midPos: float = 0

# Reference to the cat's sprite
@onready var catSprite = $CatAnim

func _ready():
	# Initialize screen size
	_screenSize = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Reference to the cat's animation player
	var catAnim = $CatAnim/AnimationPlayer
	
	# Check if the game is not allowed (perhaps due to some condition)
	if GD.isNotAllowed == true:
		if hold:
			# Move the cat horizontally with the mouse and play the fly animation
			position.x = get_global_mouse_position().x
			catAnim.play("fly")

	# Limit the character's movements to the screen
	position.x = clamp(position.x, 0, _screenSize.x)

func _on_button_gui_input(event):
	# Handle mouse button input to determine if the cat is being held
	if event is InputEventMouseButton and not hit:
		if event.pressed:
			hold = true
		else:
			hold = false
