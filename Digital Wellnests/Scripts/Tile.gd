extends Area2D

var tapped: bool
var found: bool
var value: int

func _ready():
	found = false
	$Image.animation = "T-1"
	value = 0 
	tapped = false

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and InputEventScreenTouch:
		if event.pressed and not tapped:
			$Tile.play()
			tapped = true
			get_parent().call("tileClick", self)

func _on_tile_animation_finished():
	$Tile.stop()
	$Tile.frame = 0
	
	if not tapped:
		$Image.animation = "T-1"
	else:
		$Image.animation = "T" + str(value)

func reset():
	$Image.animation = "T-1"
	var tile = $Tile
	tapped = false
	tile.frame = 0
	tile.play("Flip", true)

func _on_timer_timeout():
	queue_free()
