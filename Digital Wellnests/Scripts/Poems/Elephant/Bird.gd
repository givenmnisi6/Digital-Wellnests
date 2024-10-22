extends Area2D

func _process(delta: float) -> void:
	var speed: float = 5
	#print(get_parent()) 
	position.x -= speed / 2
