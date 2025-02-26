extends Control

@onready var opButton = $HBoxContainer/OptionButton

const RESOLUTION_DICTIONARY : Dictionary = {
	"720 × 480" : Vector2(720, 480),
	"1280 × 720" : Vector2(1280, 720),
	"1366 × 768": Vector2(1366, 768),
	"1920 ×  1080" : Vector2(1920, 1080),
	#"2560 × 1440" : Vector2(2560, 1440),
	#"3840 × 2160" : Vector2i(3840, 2160)
}

func _ready():
	addResolutionItems()
	opButton.item_selected.connect(_on_option_button_item_selected)

func addResolutionItems() -> void:
	var currentRes = Vector2(get_viewport().get_size())
	var Index = 0
	for i in RESOLUTION_DICTIONARY:
		opButton.add_item(i, Index)
		if RESOLUTION_DICTIONARY[i] == currentRes:
			opButton._select_int(Index)
		Index += 1

func _on_option_button_item_selected(index):
	var size = RESOLUTION_DICTIONARY.get(opButton.get_item_text(index))
	
	# Get the current screen size to center the window
	var screen_size = DisplayServer.screen_get_size()
	
	# Change the window size
	DisplayServer.window_set_size(size)
	
	# Center the window on screen after resizing
	# Convert to the same type (Vector2i) for the calculation
	var position = (screen_size - Vector2i(int(size.x), int(size.y))) / 2
	DisplayServer.window_set_position(position)
	
	# Make sure the window stays within screen bounds
	if position.x < 0:
		position.x = 0
	if position.y < 0:
		position.y = 0
	
	# Ensure window position is updated
	DisplayServer.window_set_position(Vector2i(position))
