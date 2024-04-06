extends Camera2D
class_name CameraController


@export var camera_zoom: float :
	get:
		return zoom.x
	set(value):
		zoom = Vector2.ONE * clampf(value, 0.2, 2)
@export var target: Node2D :
	get:
		return _target
	set(value):
		set_target(value, true)
var _target: Node2D
@export var lerp_duration: float = 0.25
var is_tweening: bool :
	get:
		return _move_tween and _move_tween.is_running()

var _move_tween: Tween


func _ready():
	set_target(target, false)


func _process(delta):
	if target and not is_tweening:
		global_position = target.global_position


func set_target(target: Node2D, lerp: bool = true, duration: float = lerp_duration):
	_target = target
	if is_inside_tree() and lerp:
		if _move_tween and _move_tween.is_running():
			_move_tween.kill()
		_move_tween = get_tree().create_tween()
		_move_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		_move_tween.tween_method(_move_tween_to_target.bind(global_position), 0.0, 1.0, duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)


func _move_tween_to_target(weight: float, start_position: Vector2):
	global_position = start_position.lerp(_target.global_position, weight)
