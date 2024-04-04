extends Node2D
class_name WormController


@export var direction: Vector2
@export var speed: float = 100
@export var segment_count: int = 8
@export var visual_segments_per_segment: int = 8
@export var visual_segment_count: int = 8
@export var visual_segment_length: float = 8
@export var turning_cone_deg: float = 1
@export var debug_draw: bool = false

var head_segment: WormSegment :
	get:
		if segments:
			return segments[0]
		return null
var tail_segment: WormSegment :
	get:
		if segments:
			return segments[segments.size() - 1]
		return null
var segments: Array[WormSegment]
var head_position: Vector2 :
	get:
		return _head_position
var head_direction: Vector2 :
	get:
		return _head_direction

@export_category("Dependencies")
@export var line_2D: Line2D
@export var worm_head: Node2D
@export var worm_tail: Node2D
@export var worm_segment_prefab: PackedScene
@export var camera: Camera2D

var _fixed_visual_segment_positions: Array[Vector2]
var _visual_segment_positions: PackedVector2Array
var _actual_direction: Vector2
var _head_position: Vector2
var _head_direction: Vector2
var _prev_debug_draw: bool

func _ready():
	segments = []
	visual_segment_count = segment_count * visual_segments_per_segment
	for i in range(segment_count):
		segments.append(worm_segment_prefab.instantiate() as WormSegment)
	_fixed_visual_segment_positions = []
	var curr_segment_pos: Vector2 = global_position
	_head_position = global_position
	for i in range(visual_segment_count):
		_fixed_visual_segment_positions.push_front(curr_segment_pos)
		curr_segment_pos.x -= visual_segment_length
	_visual_segment_positions = PackedVector2Array(_fixed_visual_segment_positions)
	line_2D.points = PackedVector2Array(_fixed_visual_segment_positions)

func _process(delta):
	# Adds fixed points to _fixed_visual_segment_positions every time the worm moves a distance of visual_segement_length
	if direction != Vector2.ZERO:
		_actual_direction = direction
		var angle_to_head = _head_direction.angle_to(direction)
		if abs(angle_to_head) > deg_to_rad(turning_cone_deg) * speed * delta:
			_actual_direction = _head_direction.rotated(deg_to_rad(turning_cone_deg) * speed * delta * sign(angle_to_head)).normalized() * direction.length()
		_head_direction = _actual_direction.normalized()
		
		var movement_delta = delta * speed
		_head_position += movement_delta * _actual_direction
		
		# Next fixed visual point starts off at the current fixed visual head point
		var next_fixed_visual_point = _fixed_visual_segment_positions[_fixed_visual_segment_positions.size() - 1]
		var fixed_visual_head_to_real_head_dir = (_head_position - next_fixed_visual_point).normalized()
		var fixed_visual_head_to_real_head_dist = next_fixed_visual_point.distance_to(_head_position)
		while fixed_visual_head_to_real_head_dist >= visual_segment_length:
			fixed_visual_head_to_real_head_dist -= visual_segment_length;
			next_fixed_visual_point += visual_segment_length * fixed_visual_head_to_real_head_dir
			_fixed_visual_segment_positions.pop_front()
			_fixed_visual_segment_positions.push_back(next_fixed_visual_point)
	
		# Lerping across fixed points to make movement smooth
		_visual_segment_positions[_visual_segment_positions.size() - 1] = head_position
		var fixed_head_to_head_dist = head_position.distance_to(_fixed_visual_segment_positions[_fixed_visual_segment_positions.size() - 1])
		var lerp_amount_per_segment = fixed_head_to_head_dist / visual_segment_length
		for i in range(_visual_segment_positions.size() - 2, -1, -1):
			_visual_segment_positions[i] = _fixed_visual_segment_positions[i].lerp(_fixed_visual_segment_positions[i + 1], lerp_amount_per_segment)
	
	# Make camera follow head, set line2D points, set head and tail sprites
	camera.global_position = _head_position
	line_2D.points = _visual_segment_positions
	worm_tail.global_position = _visual_segment_positions[0]
	worm_tail.rotation = (_visual_segment_positions[1] - _visual_segment_positions[0]).angle()
	worm_head.global_position = _visual_segment_positions[_visual_segment_positions.size() - 1]
	worm_head.rotation = (_visual_segment_positions[_visual_segment_positions.size() - 2] - _visual_segment_positions[_visual_segment_positions.size() - 1]).angle() + PI
	
	# Debug draw
	if debug_draw:
		queue_redraw()
	if _prev_debug_draw != debug_draw:
		if not debug_draw:
			queue_redraw()
		_prev_debug_draw = debug_draw

func _draw():
	if debug_draw:
		draw_line(_head_position, _head_position + _head_direction * 64, Color.RED, 3)
		draw_line(_head_position, _head_position + direction * 64, Color.GREEN, 3)
		draw_polyline(PackedVector2Array(_fixed_visual_segment_positions), Color.RED)
		for segment_pos in _fixed_visual_segment_positions:
			draw_circle(segment_pos, 4, Color.RED)
		draw_polyline(_visual_segment_positions, Color.BLUE)
		for segment_pos in _visual_segment_positions:
			draw_circle(segment_pos, 4, Color.BLUE)
		draw_circle(_head_position, 4, Color.RED)
