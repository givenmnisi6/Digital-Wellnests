extends Area2D

# Remove the coin from the scene when it collides with anything
func _on_body_entered(body: Node2D) -> void:
	queue_free()
