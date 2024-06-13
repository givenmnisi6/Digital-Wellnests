extends HSlider

@export 
var busName: String  # Name of the audio bus
var busIndex: int  # Index of the audio bus

func _ready():
	busIndex = AudioServer.get_bus_index(busName)  # Get the index of the audio bus
	value_changed.connect(_on_value_changed)  # Connect the value_changed signal to _on_value_changed function
	
	 # Set the initial value of the HSlider based on the volume of the audio bus
	value = db_to_linear(AudioServer.get_bus_volume_db(busIndex)) 

# Update the volume of the audio bus based on the value of the HSlider
func _on_value_changed(value: float):
	AudioServer.set_bus_volume_db(busIndex, linear_to_db(value))
