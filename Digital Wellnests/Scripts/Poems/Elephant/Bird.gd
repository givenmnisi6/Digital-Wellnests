extends Area2D

func _process(delta: float) -> void:
	var speed: float = 5

	# Move the bird to the left at half the defined speed
	position.x -= speed / 2
