extends Area2D

var hit: bool
var hold: bool
var _screenSize: Vector2
var midPos: float = 0
@onready var catSprite = $CatAnim

func _ready():
	_screenSize = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var catAnim = $CatAnim/AnimationPlayer
	if GD.isNotAllowed == true:
		if hold:
			position.x = get_global_mouse_position().x
			catAnim.play("fly")
#			if get_global_mouse_position() > get_viewport_rect().get_center():
#				catSprite.flip_h = false
#			elif get_global_mouse_position() < get_viewport_rect().get_center():
#				catSprite.flip_h = true

	#Limit the character's movements to the screen
	position.x = clamp(position.x, 0, _screenSize.x)


func _on_button_gui_input(event):
	if event is InputEventMouseButton and not hit:
		if event.pressed:
			hold = true
		else:
			hold = false

