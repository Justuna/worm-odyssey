extends Node
class_name PlayerWormInput


@export var worm_controller: WormController
@export var movement_deadzone: float = 32 
@export var speed_scroll_factor: float = 1.1

var _movement_deadzone_sqr: float


func _ready():
	_movement_deadzone_sqr = movement_deadzone * movement_deadzone 


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				worm_controller.speed *= speed_scroll_factor
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				worm_controller.speed /= speed_scroll_factor


func _process(delta):
	var head_to_mouse =  worm_controller.get_global_mouse_position() - worm_controller.head_segment.global_position
	if head_to_mouse.length_squared() >= _movement_deadzone_sqr:
		worm_controller.direction = head_to_mouse.normalized()
	else:
		worm_controller.direction = Vector2.ZERO
