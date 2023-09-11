extends Area2D
class_name Tile

var tapped: bool
var found: bool
var value: int

func _ready():
	found = false
	$Image.animation = "T-1"
	value = 0 
	tapped = false

func _on_tile_animation_finished():
	$Tile.stop()
	$Tile.frame = 0
	
	if not tapped:
		$Image.animation = "T-1"
	else:
		$Image.animation = "T" + str(value)

func reset():
	$Image.animation = "T-1"
	tapped = false
	$Tile.frame = 0
	$Tile.play("Flip", true)

func _on_timer_timeout():
	reset()


func _on_button_gui_input(event):
	if event is InputEventMouseButton and InputEventScreenTouch:
		if event.pressed and !tapped:
			$Tile.play()
			tapped = true
			get_parent().call("tileClick", self)
