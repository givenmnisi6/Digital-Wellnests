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
	resumeGame()
	get_tree().reload_current_scene()
