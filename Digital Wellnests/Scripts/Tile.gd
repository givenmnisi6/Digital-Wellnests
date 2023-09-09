extends Area2D

var tapped: bool
var found: bool
var value: int

func _ready():
	found = false
	#var image: AnimatedSprite2D = get_node("Image")
	get_node("Image").animation = "T-1"
	#image.animation = "T-1"
	value = 0 
	tapped = false

func _on_input_event(viewport, event, shape_idx):
	#if event is InputEventScreenTouch:
	if event is InputEventMouseButton and InputEventScreenTouch:
		#if event is InputEventMouseButton and InputEventScreenTouch and event.pressed:
		#var eventMouseButton: InputEventScreenTouch = event as InputEventScreenTouch
		
		if event.pressed and not tapped:
			$Tile.play()
			tapped = true
			
			get_parent().call("tileClick", self)


func _on_tile_animation_finished():
	#var tile: AnimatedSprite2D = get_node("Tile")
	
	$Tile.stop()
	get_node("Tile").frame = 0
	
	var image: AnimatedSprite2D = get_node("Image")
	if not tapped:
		image.animation = "T-1"
	else:
		image.animation = "T" + str(value)

func reset():
	var image: AnimatedSprite2D = get_node("Image")
	image.animation = "T-1"
	
	var tile: AnimatedSprite2D = get_node("Tile")
	tapped = false
	tile.frame = 0
	tile.play("Flip", true)

func _on_timer_timeout():
	queue_free()
