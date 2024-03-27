extends Control

@onready var opButton = $HBoxContainer/OptionButton

const RESOLUTION_DICTIONARY : Dictionary = {
	"720 × 480" : Vector2(720, 480),
	"1280 × 720" : Vector2(1280, 720),
	"1366 × 768": Vector2(1366, 768),
	"1920 ×  1080" : Vector2(1920, 1080),
	"2560 × 1440" : Vector2(2560, 1440),
	#"3840 × 2160" : Vector2i(3840, 2160)
}

func _ready():
	addResolutionItems()

func addResolutionItems() -> void:
	for i in RESOLUTION_DICTIONARY:
		opButton.add_item(i)

func _on_option_button_item_selected(index):
	var size = RESOLUTION_DICTIONARY.get(opButton.get_item_text(index))
	DisplayServer.window_set_size(size)
	#DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
