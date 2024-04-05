extends Node2D
class_name Equipment


enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

const DIRECTION_TO_RADIANS: Dictionary = {
	Direction.UP: deg_to_rad(90),
	Direction.LEFT: deg_to_rad(180),
	Direction.DOWN: deg_to_rad(270),
	Direction.RIGHT: 0
}

signal active_used
# Worm that the equipment is attached to
var worm: Node2D
# WormSegment that the equipment is attached to
var segment: WormSegment
# Direction of the equipment
var direction: Direction :
	get:
		return _direction
	set(value):
		_direction = value
		if rotated_part:
			rotated_part.rotation = DIRECTION_TO_RADIANS[_direction]
var orientable: bool

@export var rotated_part: Node2D

var _direction: Direction


func construct(_worm: Node2D, _segment: WormSegment, _direction: Direction):
	worm = _worm
	segment = _segment
	direction = _direction


func use_active():
	active_used.emit()
