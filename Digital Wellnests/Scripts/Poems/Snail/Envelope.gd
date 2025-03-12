extends Area2D

@export var Speed: float = 0.9  # Speed at which the envelope falls down the screen

# Variables for controlling the envelope's movement and position
var midPos: float = 0  # The width of each lane on the screen
var lane: int = 0      # Current lane (column) the envelope is in (0, 1, 2, etc.)
var type: int = 0      # Type of envelope (used to differentiate envelope variants)

var hold: bool  	   # Whether the envelope is being held
var hit: bool          # Whether the envelope has been hit
var _screenSize: Vector2

func _ready():
	_screenSize = get_viewport().get_size()	# Get screen dimensions
	hit = false								# Set initial animation
	$EnvelopeAnim.animation = "Wiggle"		# Envelope starts not being held
	hold = false

func _process(delta):
	# Allows the user to move the envelope anyhow
	# Else it moves on its own at a specific lane with displacement
	var envAnim = $EnvelopeAnim

	if hold:
		position = get_global_mouse_position()
		envAnim.play()
	else:
		var maxDisplace = midPos / 2
		lane = int(position.x / midPos)

		if position.x > midPos * (lane + 1) - maxDisplace:
			position = Vector2(midPos * (lane + 1) - maxDisplace, position.y + Speed)
		elif position.x < midPos * lane + maxDisplace:
			position = Vector2(midPos * lane + maxDisplace, position.y + Speed)
		else:
			position = Vector2(position.x, position.y + Speed)
		if envAnim.animation == "Wiggle":
			envAnim.stop()

func _on_button_gui_input(event):
	# Handle mouse/touch input for dragging the envelope
	if event is InputEventMouseButton and InputEventScreenTouch and not hit:
		if event.pressed:
			# Mouse button or finger down - start dragging
			hold = true
		else:
			# Mouse button or finger up - stop dragging
			hold = false

func _on_body_entered(body):
	# The envelope will shrink when it enters the area
	var envAnim = $EnvelopeAnim
	
	# Hide the envelope visually
	hide()
	
	# Emit signal to notify parent about the collision
	emit_signal("Hit")
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Play shrinking animation to show the envelope being "posted"
	envAnim.animation = "Shrink"
	envAnim.play()

	# Mark as hit to prevent further interaction
	hit = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	# Remove the envelope when it goes off-screen (cleanup)
	queue_free()
