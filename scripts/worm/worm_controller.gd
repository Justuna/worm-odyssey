extends Node2D
class_name WormController


@export var direction: Vector2
@export var speed: float = 100
@export var segment_count: int = 40
@export var length_per_segment: float = 8

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

@export_category("Dependencies")
@export var line_2D: Line2D
@export var worm_segment_prefab: PackedScene
@export var camera: Camera2D

var _visual_segment_positions: Array[Vector2]
var _leftover_movement_delta: float

func _ready():
	segments = []
	_visual_segment_positions = []
	for i in range(segment_count):
		segments.append(worm_segment_prefab.instantiate() as WormSegment)
		_visual_segment_positions.append(head_segment.global_position)

func _process(delta):
	if direction != Vector2.ZERO:
		var movement_delta = delta * speed
		var next_visual_point_position = head_segment.global_position
		head_segment.global_position += movement_delta * direction
		
		_leftover_movement_delta += movement_delta
		while _leftover_movement_delta >= length_per_segment:
			_leftover_movement_delta -= length_per_segment;
			next_visual_point_position += length_per_segment * direction
			_visual_segment_positions.pop_front()
			_visual_segment_positions.push_back(next_visual_point_position)
	
	#camera.global_position = head_segment.global_position
	
	queue_redraw()

func _draw():
	draw_polyline(PackedVector2Array(_visual_segment_positions), Color.RED)
	for segment_pos in _visual_segment_positions:
		draw_circle(segment_pos, 32, Color.RED)
