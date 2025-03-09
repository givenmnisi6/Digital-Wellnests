extends Control

# Reference to the Music audio bus for volume/mute control
var musicBus = AudioServer.get_bus_index("Music")

func _ready():
	# Display the settings panel with animation
	%AnimationPlayer.play("PopOut")

func _on_back_pressed():
	# Provide Sfx feedbacl for button press
	Music.clickSfx()
	
	# Remove settings from scene tree completely
	queue_free()

func _on_sound_button_pressed() -> void:
	# Toggle audio mute state - if sound is on, turn it off and vice versa
	AudioServer.set_bus_mute(musicBus, not AudioServer.is_bus_mute(musicBus))
	Music.clickSfx()

func _on_tab_container_tab_clicked(tab: int) -> void:
	# ClickSfx when switching between settings tabs
	Music.clickSfx()
