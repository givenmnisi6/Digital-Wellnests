extends Control

# NB! Make sure that in the Inspector, under Node the Mode is Always

# References the game node - two levels up
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

#func resumeAnimation():
	#%AnimationPlayer.play_backwards("PopOut")

# Quits the game
func quitGame():
	get_tree().quit()

# Pauses and resumes the game
func escapeButton():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pauseGame()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resumeGame()

# Calls the Pause Menu's function in the game scene
func _on_resume_button_pressed() -> void:
	Music.clickSfx()
	game.pauseMenus()

# Calls the quit function and the Sfx 
func _on_exit_button_pressed() -> void:
	Music.clickSfx()
	quitGame()

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	
	# Get the parent scene, the Main scene and return to it and free the game instance
	var mainScene = game.get_parent()
	mainScene.returnToMain()
	game.queue_free()


func _on_restart_button_pressed() -> void:
	# Unpause the game
	get_tree().paused = false
	restartGame()

func restartGame():
	# Unpause the game
	get_tree().paused = false
	
	# Get the parent (Main scene)
	var main_scene = game.get_parent()
	
	# Store the current game index (make sure to use the correct property)
	var current_game_index = game.gameIndex
	
	# Remove the old game instance
	game.queue_free()
	
	# Set the story index on the main scene
	main_scene.iStory = current_game_index
	
	# Start a new game with the same story
	main_scene.startGame()
