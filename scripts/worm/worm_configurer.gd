extends Node
class_name WormConfigurer


@export var worm: Node2D
@export var config_worm_ui: Control
@export var worm_ui: Control
@export var camera: CameraController
@export var in_config_mode: bool :
	get:
		return _in_config_mode
	set(value):
		_set_config_mode(value)
var _in_config_mode: bool
@export var in_move_mode: bool :
	get:
		return _in_move_mode
	set(value):
		_set_in_move_mode(value)
var _in_move_mode: bool
@export var equipment_library: EquipmentLibrary

var _current_segment_index: int
var _current_segment: WormSegment :
	get:
		return worm_controller.segments[_current_segment_index]
var _original_cam_zoom: float

@onready var worm_controller: WormController = worm.get_node("WormController")


func _ready():
	_original_cam_zoom = camera.camera_zoom
	_set_config_mode(false)


func toggle_config_mode():
	in_config_mode = not in_config_mode


func select_prev_segment(duration: float = camera.lerp_duration):
	if not _in_config_mode:
		return
	_select_segment(_current_segment_index - 1, duration)


func select_next_segment(duration: float = camera.lerp_duration):
	if not _in_config_mode:
		return
	_select_segment(_current_segment_index + 1, duration)


func set_segment_binding(binding: WormSegment.Binding):
	if not _in_config_mode:
		return
	var current_segment = _current_segment
	if binding == current_segment.binding:
		current_segment.binding = WormSegment.Binding.NONE
	else:
		current_segment.binding = binding


func eject_segment():
	if not _in_config_mode:
		return
	var current_segment = _current_segment
	var equipment = current_segment.remove_equipment()
	if equipment:
		var dropped_equipment = equipment_library.spawn_dropped_equipment_from_existing(equipment)
		get_parent().add_child(dropped_equipment)
		dropped_equipment.global_position = current_segment.global_position
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(dropped_equipment, "global_position", current_segment.to_global(Vector2.UP * 128), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


func rotate_segment_left():
	if not _in_config_mode:
		return
	var current_segment = _current_segment
	if current_segment.equipment:
		current_segment.direction = Equipment.rotate_left(current_segment.equipment.direction)


func rotate_segment_right():
	if not _in_config_mode:
		return
	var current_segment = _current_segment
	if current_segment.equipment:
		current_segment.direction = Equipment.rotate_right(current_segment.equipment.direction)


func _swap_segments(index_one: int, index_two: int):
	var segment_one = worm_controller.segments[index_one]
	var segment_two = worm_controller.segments[index_two]
	segment_one.swap_equipment(segment_two)


func _select_segment(index: int, duration: float = camera.lerp_duration):
	worm_controller.segments[_current_segment_index].is_selected = false
	worm_controller.segments[_current_segment_index].is_moving = false
	var prev_segment_index = _current_segment_index
	_current_segment_index = index % worm_controller.segment_count
	if in_move_mode:
		_swap_segments(prev_segment_index, _current_segment_index)
	worm_controller.segments[_current_segment_index].is_selected = true
	worm_controller.segments[_current_segment_index].is_moving = in_move_mode
	camera.set_target(worm_controller.segments[_current_segment_index], true, duration)


func _set_config_mode(value: bool):
	_in_config_mode = value
	if is_inside_tree():
		config_worm_ui.visible = _in_config_mode
		worm_ui.visible = not _in_config_mode
		get_tree().paused = _in_config_mode
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		if _in_config_mode:
			_select_segment(0)
			_original_cam_zoom = camera.camera_zoom
			tween.tween_property(camera, "camera_zoom", 0.5, 0.5)
		else:
			camera.set_target(worm_controller.worm_head)
			worm_controller.segments[_current_segment_index].is_selected = false
			worm_controller.segments[_current_segment_index].is_moving = false
			tween.tween_property(camera, "camera_zoom", _original_cam_zoom, 0.5)


func _set_in_move_mode(value: bool):
	_in_move_mode = value
	if is_inside_tree():
		_current_segment.is_moving = in_move_mode
