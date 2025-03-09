extends Control

@onready var opButton = $HBoxContainer/OptionButton

const RESOLUTION_DICTIONARY : Dictionary = {
	"720 × 480" : Vector2i(720, 480),
	"1280 × 720" : Vector2i(1280, 720),
	"1366 × 768": Vector2i(1366, 768),
	"1920 × 1080" : Vector2i(1920, 1080),
	# Higher resolutions commented out - may be enabled for devices that support them
	#"2560 × 1440" : Vector2i(2560, 1440),
	#"3840 × 2160" : Vector2i(3840, 2160)
}

func _ready():
	addResolutionItems()
	opButton.item_selected.connect(_on_option_button_item_selected)

func addResolutionItems() -> void:
	# Get current viewport size to find matching resolution in dropdown
	var currentRes = Vector2i(get_viewport().get_size())

	# Populate dropdown with resolution options
	var Index = 0
	for i in RESOLUTION_DICTIONARY:
		opButton.add_item(i, Index)
		 # Select current resolution in dropdown if it exists in our options
		if RESOLUTION_DICTIONARY[i] == currentRes:
			opButton._select_int(Index)
		Index += 1

func _on_option_button_item_selected(index):
	var size = RESOLUTION_DICTIONARY.get(opButton.get_item_text(index))
	
	# Get the current screen size to center the window
	var screen_size = DisplayServer.screen_get_size()
	
	# Apply the new resolution
	DisplayServer.window_set_size(size)
	
	# Calculate position to center window on screen
	# Convert to Vector2i for compatibility with DisplayServer methods
	var position = (screen_size - Vector2i(int(size.x), int(size.y))) / 2
	DisplayServer.window_set_position(position)
	
	# Prevent window from being positioned off-screen
	if position.x < 0:
		position.x = 0
	if position.y < 0:
		position.y = 0
	
	# Update window position to centered coordinates
	DisplayServer.window_set_position(Vector2i(position))
