extends CharacterBody2D

# Gravity constant - controls downward acceleration
const GRAVITY: int = 4200

# Jump speed constant - determines the initial upward velocity when jumping
const JUMP_SPEED: int = -1370

# Game state variables
var isActive = false  # Controls whether the game (specifically jumping) is active
var touchJump = false  # Tracks if jump is triggered by screen touch
var can_jump = true  # Prevents multiple jumps without releasing

# Handle input events (screen touches)
func _input(event: InputEvent) -> void:
	# Only process input if the game is active and not paused
	if isActive and !get_tree().paused:
		if event is InputEventScreenTouch:
			# On touch press, enable jumping
			if event.pressed and can_jump:
				touchJump = true
				can_jump = false
			# On touch release, reset jump state
			elif !event.pressed:
				touchJump = false
				can_jump = true

# Physics processing - handles movement and animations
func _physics_process(delta: float) -> void:
	# Completely stop processing if not active or game is paused
	if !isActive or get_tree().paused:
		# Reset velocity to prevent any residual movement
		velocity = Vector2.ZERO
		return
	
	# Apply gravity
	velocity.y += GRAVITY * delta
	
	# Handle jumping and animation states
	if is_on_floor():
		# Jump when accept action or touch jump is triggered
		if Input.is_action_pressed("ui_accept") or touchJump:
			jump()
		else:
			# Play running animation when on floor
			$AnimatedSprite2D.play("run")
	else:
		# Play jumping animation when in air
		$AnimatedSprite2D.play("jump")
	
	# Apply movement
	move_and_slide()

# Execute jump action
func jump() -> void:
	# Set vertical velocity to jump speed (upward)
	velocity.y = JUMP_SPEED
	# Play jumping sound
	$Jump.play()

# Set the active state of the game
func setActive(active: bool) -> void:
	isActive = active

# Make the texture button visible
func makeVisible() -> void:
	$CanvasLayer/TextureButton.visible = true

# Hide the texture button
func makeInvisible() -> void:
	$CanvasLayer/TextureButton.visible = false

# Handle texture button press down
func _on_texture_button_button_down() -> void:
	touchJump = true

# Handle texture button release
func _on_texture_button_button_up() -> void:
	touchJump = false

# Stop the jumping sound
func stopJumpingSound() -> void:
	$Jump.stop()
