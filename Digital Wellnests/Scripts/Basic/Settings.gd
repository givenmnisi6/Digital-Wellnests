extends Control

var musicBus = AudioServer.get_bus_index("Music")

func _ready():
	%AnimationPlayer.play("PopOut")

func _on_back_pressed():
	# Play the click sound effect
	Music.clickSfx()
	
	# Hide the SettingsPage node
	#%AnimationPlayer.play_backwards("PopOut")
	queue_free()
	#$SettingsPage.hide()

func _on_sound_button_pressed() -> void:
	# Toggle the mute state of the music bus
	AudioServer.set_bus_mute(musicBus, not AudioServer.is_bus_mute(musicBus))
	Music.clickSfx()

func _on_tab_container_tab_clicked(tab: int) -> void:
	Music.clickSfx()
