extends Node
class_name ControllerWormInput


@export var zoom_factor: float = 0.1
@export var zoom_deadzone: float = 0.1
@export var movement_deadzone: float = 0.1
@export var device_id: int = 0
@export var auto_find_device: bool = false
@export var move_segment_interval_max: float = 1
@export var move_segment_interval_count_max: int = 4
@export var move_segment_interval_curve: Curve

@export_category("Dependencies")
@export var worm: Node2D
@export var camera_controller: CameraController
@export var worm_configurer: WormConfigurer

@onready var _worm_controller: WormController = worm.get_node("WormController")
@onready var _interactor: Interactor = worm.get_node("Interactor")
var _movement_deadzone_sqr: float
var _interact_pressed: bool
var _config_mode_pressed: bool
var _move_segment_interval: float
var _move_segment_interval_count: int
var _move_segment_interval_timer: float
var _move_segment_pressed: bool
var _binding_button_pressed: bool 
var _eject_button_pressed: bool
var _rotate_pressed: bool

func _ready():
	_movement_deadzone_sqr = movement_deadzone * movement_deadzone 


func _process(delta):
	if auto_find_device:
		var joypad_ids = Input.get_connected_joypads()
		if joypad_ids.size() > 0:
			device_id = joypad_ids[0]
	if worm_configurer.in_config_mode:
		var dpad_up = Input.is_joy_button_pressed(device_id, JOY_BUTTON_DPAD_UP)
		var dpad_down = Input.is_joy_button_pressed(device_id, JOY_BUTTON_DPAD_DOWN)
		if dpad_up or dpad_down:
			if not _move_segment_pressed:
				_move_segment_pressed = true
				_move_segment_interval_count = 0
				_move_segment_interval_timer = 1.0
				_move_segment_interval = 0
			_move_segment_interval_timer += delta
			if _move_segment_interval_timer > _move_segment_interval:
				_move_segment_interval = move_segment_interval_curve.sample(float(_move_segment_interval_count) / move_segment_interval_count_max) * move_segment_interval_max
				if dpad_up:
					worm_configurer.select_next_segment(_move_segment_interval)
				else:
					worm_configurer.select_prev_segment(_move_segment_interval)
				_move_segment_interval_timer = 0.0
				if _move_segment_interval_count < move_segment_interval_count_max:
					_move_segment_interval_count += 1
		elif _move_segment_pressed:
			_move_segment_pressed = false
		var a_pressed = Input.is_joy_button_pressed(device_id, JOY_BUTTON_A)
		var b_pressed = Input.is_joy_button_pressed(device_id, JOY_BUTTON_B)
		var x_pressed = Input.is_joy_button_pressed(device_id, JOY_BUTTON_X)
		var y_pressed = Input.is_joy_button_pressed(device_id, JOY_BUTTON_Y)
		if a_pressed or b_pressed or x_pressed or y_pressed:
			if not _binding_button_pressed:
				if a_pressed:
					worm_configurer.set_segment_binding(WormSegment.Binding.A_BUTTON)
				elif b_pressed:
					worm_configurer.set_segment_binding(WormSegment.Binding.B_BUTTON)
				elif x_pressed:
					worm_configurer.set_segment_binding(WormSegment.Binding.Y_BUTTON)
				elif y_pressed:
					worm_configurer.set_segment_binding(WormSegment.Binding.X_BUTTON)
				_binding_button_pressed = true
		elif _binding_button_pressed:
			_binding_button_pressed = false
		worm_configurer.in_move_mode = Input.get_joy_axis(device_id, JOY_AXIS_TRIGGER_RIGHT) > 0.25
		if Input.is_joy_button_pressed(device_id, JOY_BUTTON_RIGHT_SHOULDER):
			if not _eject_button_pressed:
				_eject_button_pressed = true
		elif _eject_button_pressed:
			_eject_button_pressed = false
			worm_configurer.eject_segment()
		var dpad_left = Input.is_joy_button_pressed(device_id, JOY_BUTTON_DPAD_LEFT)
		var dpad_right = Input.is_joy_button_pressed(device_id, JOY_BUTTON_DPAD_RIGHT)
		if dpad_left or dpad_right:
			if not _rotate_pressed:
				_rotate_pressed = true
				if dpad_left:
					worm_configurer.rotate_segment_left()
				else:
					worm_configurer.rotate_segment_right()
		elif _rotate_pressed:
			_rotate_pressed = false
	else:
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
