extends Node2D
class_name WormController


signal on_death

@export var direction: Vector2
@export var speed: float = 100
@export var segment_count: int = 32
@export var visual_segments_per_segment: int = 8
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
		return worm_head.global_position
var head_direction: Vector2 :
	get:
		return _head_direction

@export_group("Dependencies")
@export var team: Team
@export var line_2D: Line2D
@export var worm_head: CharacterBody2D
@export var worm_tail: Node2D
@export var worm_segment_prefab: PackedScene
@export var segments_container: Node2D

var _fixed_visual_segment_positions: Array[Vector2]
var _visual_segment_positions: PackedVector2Array
var _visual_segment_count: int;
var _actual_direction: Vector2
var _head_direction: Vector2
var _prev_debug_draw: bool


func _ready():
	segments = []
	_visual_segment_count = segment_count * visual_segments_per_segment
	for i in range(segment_count):
		_add_segment()
	_fixed_visual_segment_positions = []
	var curr_segment_pos: Vector2 = global_position
	worm_head.global_position = global_position
	for i in range(_visual_segment_count):
		_fixed_visual_segment_positions.append(curr_segment_pos)
		curr_segment_pos.x -= visual_segment_length
	_visual_segment_positions = PackedVector2Array(_fixed_visual_segment_positions)
	line_2D.points = _visual_segment_positions


func _process(delta):
	# Adds fixed points to _fixed_visual_segment_positions every time the worm moves a distance of visual_segement_length
	if direction != Vector2.ZERO:
		_actual_direction = direction
		var angle_to_head = _head_direction.angle_to(direction)
		if abs(angle_to_head) > deg_to_rad(turning_cone_deg) * speed * delta:
			_actual_direction = _head_direction.rotated(deg_to_rad(turning_cone_deg) * speed * delta * sign(angle_to_head)).normalized() * direction.length()
		if worm_head.get_slide_collision_count() > 0 and worm_head.get_real_velocity().length_squared() < 0.5 * speed * delta:
				_actual_direction = worm_head.get_real_velocity().normalized()
		
		worm_head.velocity = _actual_direction * speed
		worm_head.move_and_slide()
		
		if worm_head.get_real_velocity().length_squared() > 1:
			_head_direction = _actual_direction.normalized()
		
		# Next fixed visual point starts off at the current fixed visual head point
		var next_fixed_visual_point = _fixed_visual_segment_positions[0]
		var fixed_visual_head_to_real_head_dir = (worm_head.global_position - next_fixed_visual_point).normalized()
		var fixed_visual_head_to_real_head_dist = next_fixed_visual_point.distance_to(worm_head.global_position)
		while fixed_visual_head_to_real_head_dist >= visual_segment_length:
			fixed_visual_head_to_real_head_dist -= visual_segment_length;
			next_fixed_visual_point += visual_segment_length * fixed_visual_head_to_real_head_dir
			_fixed_visual_segment_positions.pop_back()
			_fixed_visual_segment_positions.push_front(next_fixed_visual_point)
	
		# Lerping across fixed points to make movement smooth
		_visual_segment_positions[0] = head_position
		var fixed_head_to_head_dist = head_position.distance_to(_fixed_visual_segment_positions[0])
		var lerp_amount_per_segment = fixed_head_to_head_dist / visual_segment_length
		for i in range(1, _visual_segment_positions.size()):
			_visual_segment_positions[i] = _fixed_visual_segment_positions[i].lerp(_fixed_visual_segment_positions[i - 1], lerp_amount_per_segment)
		
	line_2D.points = _visual_segment_positions
	worm_tail.global_position = _visual_segment_positions[_visual_segment_positions.size() - 1]
	worm_tail.rotation = (_visual_segment_positions[_visual_segment_positions.size() - 2] - _visual_segment_positions[_visual_segment_positions.size() - 1]).angle()
	worm_head.rotation = (_visual_segment_positions[1] - _visual_segment_positions[0]).angle() + PI
	for i in range(segments.size()):
		segments[i].global_position = _visual_segment_positions[(i + 1) * visual_segments_per_segment - 1]
		segments[i].global_rotation = segments[i].global_position.angle_to_point(_visual_segment_positions[i * visual_segments_per_segment + 1])
	
	# Debug draw
	if debug_draw:
		queue_redraw()
	if _prev_debug_draw != debug_draw:
		if not debug_draw:
			queue_redraw()
		_prev_debug_draw = debug_draw


## Uses the active abilities of all equipment
## bound to a given binding.
func use_active(binding: WormSegment.Binding):
	assert(binding != WormSegment.Binding.NONE)
	for segment in segments:
		if segment.binding == binding:
			segment.use_active()


## Tries to add an equipment into the first empty slot
## on the worm. Returns true if successful, and false
## if the worm has no empty slots.
func try_add_equipment(equipment: Equipment) -> bool:
	for segment in segments:
		if segment.equipment == null:
			segment.add_equipment(equipment, Equipment.Direction.UP)
			return true
	return false


func _draw():
	if debug_draw:
		draw_circle(worm_head.global_position + _actual_direction * 64, 8, Color.PURPLE)
		draw_line(worm_head.global_position, worm_head.global_position + _head_direction * 64, Color.RED, 3)
		draw_line(worm_head.global_position, worm_head.global_position + direction * 64, Color.GREEN, 3)
		draw_polyline(PackedVector2Array(_fixed_visual_segment_positions), Color.RED)
		for segment_pos in _fixed_visual_segment_positions:
			draw_circle(segment_pos, 4, Color.RED)
		draw_polyline(_visual_segment_positions, Color.BLUE)
		for segment_pos in _visual_segment_positions:
			draw_circle(segment_pos, 4, Color.BLUE)
		draw_circle(worm_head.global_position, 4, Color.RED)


func grow():
	_add_segment()
	segment_count += 1

	var last_visual_segment_pos = _visual_segment_positions[_visual_segment_count - 1]
	var last_fixed_segment_pos = _fixed_visual_segment_positions[_visual_segment_count - 1]
	var last_segment_dir = (_visual_segment_positions[_visual_segment_count - 1] - _visual_segment_positions[_visual_segment_count - 2]).normalized()
	_visual_segment_count += visual_segments_per_segment
	for i in range(0, visual_segments_per_segment):
		var delta = last_segment_dir * visual_segment_length
		last_visual_segment_pos += delta
		last_fixed_segment_pos += delta
		_fixed_visual_segment_positions.append(last_visual_segment_pos)
		_visual_segment_positions.append(last_fixed_segment_pos)


func _add_segment():
	var segment_inst = worm_segment_prefab.instantiate() as WormSegment
	segment_inst.construct(self, team.team)
	segments_container.add_child(segment_inst)
	segments.append(segment_inst)

	segment_inst.on_death.connect(_remove_segment.bind(segment_inst))


func _remove_segment(segment: WormSegment):
	segments.erase(segment)
	segment.queue_free()
	segment_count -= 1

	_visual_segment_count -= visual_segments_per_segment
	for i in range(0, visual_segments_per_segment):
		_fixed_visual_segment_positions.pop_back()
		_visual_segment_positions.remove_at(_visual_segment_positions.size() - 1)
	
	if segment_count == 0:
		on_death.emit()
		get_parent().queue_free()
