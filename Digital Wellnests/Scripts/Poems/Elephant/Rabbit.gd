extends CharacterBody2D

# pushes the player down
const GRAVITY : int = 4200
# pushes the player up
const JUMP_SPEED: int = -1370

var isActive = false
var touch_jump = false

#func _input(event: InputEvent) -> void:
	#if isActive and !get_tree().paused:
		#if event is InputEventScreenTouch and event.pressed:
			#jump()

func _physics_process(delta: float) -> void:
	if isActive and !get_tree().paused:
		velocity.y += GRAVITY * delta

		# if the player is on the floor, do the following, else jump
		if is_on_floor():
			# Enable the running collisions
			if Input.is_action_pressed("ui_accept") or touch_jump == true:
				jump()
			else:
				$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("jump")
		move_and_slide()

func jump():
	velocity.y = JUMP_SPEED
	$Jump.play()

func setActive(active: bool) -> void:
	isActive = active

#func _physics_process(delta: float) -> void:
#
	#velocity.y += GRAVITY * delta
#
	## if the player is on the floor, do the following, else jump
	#if is_on_floor():
		## Enable the running collisions
		#if Input.is_action_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#jump()
		#else:
			#$AnimatedSprite2D.play("run")
	#else:
		#$AnimatedSprite2D.play("jump")
	#move_and_slide()
#
#func jump():
	#velocity.y = JUMP_SPEED
	#$Jump.play()

func makeVisible():
	$CanvasLayer/TextureButton.visible = true

func makeInvisible():
	$CanvasLayer/TextureButton.visible = false

func _on_texture_button_button_down() -> void:
	touch_jump = true

func _on_texture_button_button_up() -> void:
	touch_jump = false
