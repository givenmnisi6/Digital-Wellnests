extends Control

# NB! Make sure that in the Inspector, under Node the Mode is Always

# References the game node (parent of parent)
@onready var game = $"../../"

# Checks if the esc button is pressed
func _process(delta: float) -> void:
	escapeButton()

# Resumes the game 
func resumeGame():
	get_tree().paused = false

# Pauses the game
func pauseGame():
	get_tree().paused = true

func pauseAnimation():
	%AnimationPlayer.play("PopOut")

# Quits the game
func quitGame():
	get_tree().quit()

# Pauses and resumes the game
func escapeButton():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pauseGame()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resumeGame()

# Handle the resume button press
func _on_resume_button_pressed() -> void:
	Music.clickSfx()
	game.pauseMenus()

# Handle the menu button press - return to main menu
func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	
	# Get the parent scene (Main scene) and return to it
	var mainScene = game.get_parent()
	mainScene.returnToMain()
	game.queue_free()

# Handle restart button press
func _on_restart_button_pressed() -> void:
	# Unpause the game
	get_tree().paused = false
	restartGame()

# Restart the current game
func restartGame():
	# Unpause the game
	get_tree().paused = false
	
	# Get the parent (Main scene)
	var mainScene = game.get_parent()
	
	# Store the current game index
	var currentGameIndex = game.gameIndex
	
	# Remove the old game instance
	game.queue_free()
	
	# Set the story index on the main scene and start a new game
	mainScene.iStory = currentGameIndex
	mainScene.startGame()

# Show the instructions panel with game-specific content
func _on_how_to_button_pressed() -> void:
	$Instructions.show()
	Music.clickSfx()
	$Instructions/InstructionsAnimationPlayer.play("PopUp")
	$Instructions/HowTo.texture = ResourceLoader.load("res://Images/GameEx" + str(game.gameIndex) + ".png")
	$Panel.hide()

# Handle back button in instructions panel
func _on_back_button_pressed() -> void:
	$Instructions.hide()
	Music.clickSfx()
	$Instructions/InstructionsAnimationPlayer.play_backwards("PopUp")
	$Panel.show()
