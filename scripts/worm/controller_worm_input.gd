extends Node
class_name ControllerWormInput


@export var zoom_factor: float = 0.1
@export var zoom_deadzone: float = 0.1
@export var movement_deadzone: float = 0.1
@export var device_id: int = 0
@export var auto_find_device: bool = false

@export_category("Dependencies")
@export var worm: Node2D
@export var camera_controller: CameraController
@export var worm_configurer: WormConfigurer

@onready var _worm_controller: WormController = worm.get_node("WormController")
@onready var _interactor: Interactor = worm.get_node("Interactor")
var _movement_deadzone_sqr: float
var _interact_pressed: bool
var _config_mode_pressed: bool

func _ready():
	_movement_deadzone_sqr = movement_deadzone * movement_deadzone 


func _process(delta):
	if auto_find_device:
		var joypad_ids = Input.get_connected_joypads()
		if joypad_ids.size() > 0:
			device_id = joypad_ids[0]
	if not worm_configurer.in_config_mode:
		var movement_dir = Vector2(Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X), Input.get_joy_axis(device_id, JOY_AXIS_LEFT_Y))
		if movement_dir.length_squared() < movement_deadzone:
			movement_dir = Vector2.ZERO
		_worm_controller.direction = movement_dir
		if Input.is_joy_button_pressed(device_id, JOY_BUTTON_RIGHT_SHOULDER):
			if not _interact_pressed:
				_interact_pressed = true
				_interactor.interact_closest()
		elif _interact_pressed:
			_interact_pressed = false
		var zoom_amount = Input.get_joy_axis(device_id, JOY_AXIS_TRIGGER_LEFT) - Input.get_joy_axis(device_id, JOY_AXIS_TRIGGER_RIGHT)
		if abs(zoom_amount) > zoom_deadzone:
			if zoom_amount > 0:
				camera_controller.camera_zoom *= (1 + zoom_factor * zoom_amount)
			else:
				camera_controller.camera_zoom /= (1 + zoom_factor * abs(zoom_amount))
	if Input.is_joy_button_pressed(device_id, JOY_BUTTON_LEFT_SHOULDER):
		if not _config_mode_pressed:
			_config_mode_pressed = true
			worm_configurer.toggle_config_mode()
	elif _config_mode_pressed:
		_config_mode_pressed = false
