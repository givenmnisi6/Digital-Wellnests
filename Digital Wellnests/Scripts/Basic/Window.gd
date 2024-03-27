extends Control

@onready var opButton = $HBoxContainer/OptionButton

# Creating a windows mode string array
const WINDOW_MODE : Array[String] = [
	"Windowed",
	"Fullscreen",
	"Borderless Fullscreen",
	"Borderless Windowed"
]

func _ready():
	# Select items in the dropdown menu
	addWindowItems()
	opButton.item_selected.connect(_on_window_selected)

func addWindowItems() -> void:
	for i in WINDOW_MODE:
		opButton.add_item(i)

func _on_window_selected(index: int) -> void:
	match index:
		# Window Mode
		0: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		# Fullscreen mode
		1: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		# Borderless Window
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		# Borderless Fullscreen
		3: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)


func _on_option_button_item_selected(index):
	pass # Replace with function body.
