extends Node
class_name KeyboardWormInput


@export var movement_deadzone: float = 32 
@export var speed_scroll_factor: float = 1.1

@onready var _worm_controller = get_parent().get_node("WormController")
var _movement_deadzone_sqr: float


func _ready():
	_movement_deadzone_sqr = movement_deadzone * movement_deadzone 


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_worm_controller.speed *= speed_scroll_factor
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_worm_controller.speed /= speed_scroll_factor
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_D:
			_worm_controller.debug_draw = not _worm_controller.debug_draw


func _process(delta):
	var head_to_mouse =  _worm_controller.get_global_mouse_position() - _worm_controller.head_position
	if head_to_mouse.length_squared() >= _movement_deadzone_sqr:
		_worm_controller.direction = head_to_mouse.normalized()
	else:
		_worm_controller.direction = Vector2.ZERO
