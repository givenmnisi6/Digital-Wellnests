extends CharacterBody2D

# pushes the player down
const GRAVITY : int = 4200
# pushes the player up
const JUMP_SPEED: int = -1370

# These variables control the state of this game
# Controls if the Rabbit game is active, specifically the jumping
# Checks whether the jump is triggered by the jump input: i.e. tapping on the screen using a mouse
var isActive = false
var touchJump = false

#func _input(event: InputEvent) -> void:
	#if isActive and !get_tree().paused:
		#if event is InputEventScreenTouch and event.pressed:
			#jump()

func _physics_process(delta: float) -> void:
	if isActive and !get_tree().paused:
		# Applying gravity to the player
		velocity.y += GRAVITY * delta

		# if the player is on the floor, do the following, else jump
		if is_on_floor():
			# Enable the running collisions
			if Input.is_action_pressed("ui_accept") or touchJump == true:
				jump()
			else:
				$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("jump")
		# Moves the player based on the velocity
		move_and_slide()

# Method for handling jumping
func jump():
	velocity.y = JUMP_SPEED
	# Play the jumping music
	$Jump.play()

# Deactivate jumping
func setActive(active: bool) -> void:
	isActive = active

# These two functions (makeVisible, makeInvisible) will be used in the game scene
# For making the texture visible and invisible when the playerJumps
func makeVisible():
	$CanvasLayer/TextureButton.visible = true

func makeInvisible():
	$CanvasLayer/TextureButton.visible = false

func _on_texture_button_button_down() -> void:
	touchJump = true

func _on_texture_button_button_up() -> void:
	touchJump = false
