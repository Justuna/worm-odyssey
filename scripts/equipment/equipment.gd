extends Node2D
class_name Equipment


enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

enum Type {
	BOW,
	FIRE_TOME,
	ICE_TOME,
	POISON_TOME
}

const DIRECTION_TO_RADIANS: Dictionary = {
	Direction.UP: deg_to_rad(90),
	Direction.LEFT: deg_to_rad(180),
	Direction.DOWN: deg_to_rad(270),
	Direction.RIGHT: 0
}

signal equipment_added
signal equipment_removed
signal active_used
signal cooldown_ended

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
@export var cooldown: float

@export var equipment_type: Type

@export_group("Dependencies")
@export var rotated_part: Node2D

@onready var team: Team = get_node("Team")
@onready var stat_block: StatBlock = get_node("StatBlock")

var _direction: Direction
var _cooldown_timer: float


func construct(_worm: Node2D, _segment: WormSegment, _direction: Direction):
	worm = _worm
	segment = _segment
	direction = _direction
	team.team = _segment.team.team
	equipment_added.emit()


func destruct():
	stat_block.clear_modifiers()
	equipment_removed.emit()


func use_active() -> bool:
	if _cooldown_timer > 0:
		return false

	active_used.emit()
	_cooldown_timer = cooldown

	return true


func _process(delta):
	if _cooldown_timer > 0:
		_cooldown_timer = max(_cooldown_timer - delta, 0)
		if _cooldown_timer == 0:
			cooldown_ended.emit()


static func rotate_left(direction: Direction) -> Direction:
	match direction:
		Direction.UP:
			return Direction.RIGHT
		Direction.RIGHT:
			return Direction.DOWN
		Direction.DOWN:
			return Direction.LEFT
	return Direction.UP


static func rotate_right(direction: Direction) -> Direction:
	match direction:
		Direction.UP:
			return Direction.LEFT
		Direction.LEFT:
			return Direction.DOWN
		Direction.DOWN:
			return Direction.RIGHT
	return Direction.UP
