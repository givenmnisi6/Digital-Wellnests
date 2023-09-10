extends Area2D

@export var Speed: float = 0.9
var midPos: float = 0
var lane: int = 0
var type: int = 0

var hold: bool
var hit: bool
var _screenSize: Vector2

func _ready():
	_screenSize = get_viewport().size
	hit = false
	
	$EnvelopeAnim.animation = "Wiggle"
	
	print("Start")
	hold = false

func _process(delta):
	var envAnim = $EnvelopeAnim
	
	if hold:
		position = get_global_mouse_position()
		envAnim.play()
	else:
		var maxDisplace = midPos/2
		lane = int(position.x/midPos)
		
		if position.x > midPos * (lane + 1) - maxDisplace:
			position = Vector2(midPos * (lane + 1) - maxDisplace, position.y + Speed)
		elif  position.x < midPos * lane + maxDisplace:
			position = Vector2(midPos * lane + maxDisplace, position.y + Speed)
		else:
			position = Vector2(position.x, position.y + Speed)
		if envAnim.animation == "Wiggle":
			envAnim.stop()

func _on_button_gui_input(event):
	if event is InputEventMouseButton and InputEventScreenTouch and not hit:
		if event.pressed:
			print("Hold")
			hold = true
		else:
			hold = false

func _on_body_entered(body):
	var envAnim = $EnvelopeAnim
	hide()
	emit_signal("Hit")
	get_node("CollisionShape2D").set_deferred("disabled", true)
	envAnim.animation = "Shrink"
	envAnim.play()
	hit = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
