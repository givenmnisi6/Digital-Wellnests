extends CharacterBody2D

# pushes the player down
const GRAVITY : int = 4200
# pushes the player up
const JUMP_SPEED: int = -1400

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	
	# if the player is on the floor, do the following, else jump
	if is_on_floor():
		# Enable the running collisions
		if Input.is_action_pressed("ui_accept"):
			velocity.y = JUMP_SPEED
			$Jump.play()
		else:
			$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("jump")
	move_and_slide()
