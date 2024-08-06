extends RigidBody2D

func _on_button_pressed() -> void:
	queue_free()


func _on_visibility_timer_timeout() -> void:
	queue_free()
