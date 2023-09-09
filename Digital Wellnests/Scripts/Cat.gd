extends Area2D

var hit: bool
var hold: bool
var _screenSize: Vector2
var midPos: float = 0

func _ready():
	_screenSize = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var catAnim = $CatAnim/AnimationPlayer
	if hold:
		position.x = get_global_mouse_position().x
		catAnim.play("fly")

	#Limit the character's movements to the screen
	position.x = clamp(position.x, 0, _screenSize.x)
	#position.y = clamp(position.y, 0, _screenSize.y)


func _on_button_gui_input(event):
	if event is InputEventMouseButton and not hit:
		if event.pressed:
			hold = true
		else:
			hold = false
