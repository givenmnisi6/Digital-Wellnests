extends Control

@onready var game = $"../../"

func _process(delta: float) -> void:
	escapeButton()

func resumeGame():
	get_tree().paused = false

func pauseGame():
	get_tree().paused = true

func quitGame():
	get_tree().quit()

func escapeButton():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pauseGame()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resumeGame()

func _on_resume_button_pressed() -> void:
	game.pauseMenus()

func _on_exit_button_pressed() -> void:
	quitGame()
