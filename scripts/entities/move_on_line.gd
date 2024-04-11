class_name MoveOnLine
extends Node2D


const SPEED_FACTOR: float = 4

@export var start_at_index: int = 0
@export var line_2d: Line2D
@export var target: Node2D
@export var speed_factor: float
@export var speed_stat: Stat
@export var reverse: bool
@export var debug_draw: bool


var _curr_index = 0
var _next_dest_point: Vector2 :
	get:
		return line_2d.global_position + line_2d.points[_curr_index]

var speed_amount: float :
	get:
		if speed_stat:
			return speed_factor * speed_stat.amount * SPEED_FACTOR
		return speed_factor


func _ready():
	line_2d.visible = false
	if start_at_index >= 0 and is_instance_valid(target):
		target.global_position = line_2d.points[start_at_index]
		_curr_index = start_at_index


func _process(delta):
	if is_instance_valid(target):
		var initial_dest = _next_dest_point
		var dist_remaining = target.global_position.distance_to(initial_dest)
		var move_amount = delta * speed_amount
		if dist_remaining > move_amount:
			target.global_position += move_amount * target.global_position.direction_to(_next_dest_point)
		else:
			var prev_dest: Vector2
			while dist_remaining <= move_amount:
				prev_dest = _next_dest_point
				if reverse:
					_curr_index -= 1
				else:
					_curr_index += 1
				_curr_index = _curr_index % line_2d.points.size()
				dist_remaining += initial_dest.distance_to(_next_dest_point)
				initial_dest = _next_dest_point
			var dist_to_next_pos = dist_remaining - move_amount
			target.global_position = _next_dest_point + _next_dest_point.direction_to(prev_dest) * dist_to_next_pos
	if debug_draw:
		queue_redraw()

func _draw():
	if debug_draw:
		for point in line_2d.points:
			draw_circle(to_local(point), 8, Color.ORANGE)
		draw_circle(to_local(_next_dest_point), 8, Color.RED)
