extends Control

@onready var opButton = $HBoxContainer/OptionButton

# These options will be displayed in the dropdown menu
const WINDOW_MODE : Array[String] = [
	"Windowed",
	"Fullscreen",
	"Borderless Windowed",
	"Borderless Fullscreen"
]

func _ready():
	# Populate the dropdown with window mode options and connect the signal
	addWindowItems()
	opButton.item_selected.connect(_on_window_selected)

func addWindowItems() -> void:
	for i in WINDOW_MODE:
		opButton.add_item(i)

func _on_window_selected(index: int) -> void:
	match index:
		# Window Mode - Standard window with borders
		0: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		# Fullscreen mode - Covers the entire screen with borders
		1: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		 # Borderless Window - Window without borders but not covering the entire screen
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		# Borderless Fullscreen - Covers the entire screen without borders
		3: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
