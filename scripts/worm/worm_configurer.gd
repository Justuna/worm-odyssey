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

@onready var worm_controller: WormController = worm.get_node("WormController")


func _ready():
	_set_config_mode(false)


func toggle_config_mode():
	in_config_mode = not in_config_mode


func _set_config_mode(value):
	_in_config_mode = value
	if is_inside_tree():
		config_worm_ui.visible = _in_config_mode
		worm_ui.visible = not _in_config_mode
		get_tree().paused = _in_config_mode
		if _in_config_mode:
			camera.set_target(worm_controller.segments[0])
		else:
			camera.set_target(worm_controller.worm_head)
