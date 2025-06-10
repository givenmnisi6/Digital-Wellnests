extends Control

func _ready() -> void:
	# Show the Exit Page
	%ExitAnimationPlayer.play("popExit")
	$ExitPage.show()
	
	$Effects.stream = load("res://Audio/Voice/Quit.wav")
	$Effects.play()

	# Create a tween for animation
	var twn = get_tree().create_tween()
	
	# Get the yButton and nButton nodes
	var y = $ExitPage/Panel/yButton
	var n = $ExitPage/Panel/nButton

	# Scale up the yButton and nButton nodes
	twn.tween_property(y, "scale", Vector2(1,1), 0.4)
	twn.tween_property(n, "scale", Vector2(1,1), 0.4)

func _on_n_button_pressed():
	# Play the click sound effect
	Music.clickSfx()
	
	$Effects.stop()
	
	# Hide the ExitPage node
	#$ExitPage.hide()
	%ExitAnimationPlayer.play_backwards("popExit")

func _on_y_button_pressed():
	# Play the click sound effect
	Music.clickSfx()
	
	# Quit the game
	%ExitAnimationPlayer.play_backwards("popExit")
	get_tree().quit()
