extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	%AnimationPlayer.play("PopOut")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_back_pressed():
	# Play the click sound effect
	Music.clickSfx()
	
	# Hide the SettingsPage node
	%AnimationPlayer.play_backwards("PopOut")
	queue_free()
	#$SettingsPage.hide()
