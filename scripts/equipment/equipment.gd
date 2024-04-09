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

signal equipment_added
signal equipment_removed
signal equipped_changed
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
@export var cooldown: float

## Is the equipment attached to a worm segment?
var is_equipped: bool
var is_active_on_cooldown: bool :
	get:
		return cooldown_timer > 0

@export_group("Dependencies")
@export var rotated_part: Node2D

@onready var team: Team = get_node("Team")
@onready var stat_block: StatBlockProxy = get_node("StatBlockProxy")

var cooldown_timer: float

var _direction: Direction


func construct(_worm: Node2D, _segment: WormSegment, _direction: Direction):
	worm = _worm
	segment = _segment
	direction = _direction
	team.team = _segment.team.team
	stat_block.source_stat_block = segment.stat_block
	is_equipped = true
	equipment_added.emit()
	equipped_changed.emit()


func destruct():
	worm = null
	segment = null
	direction = Direction.UP
	team.team = ""
	is_equipped = false
	equipment_removed.emit()
	equipped_changed.emit()


func use_active() -> bool:
	if cooldown_timer > 0:
		return false

	active_used.emit()
	cooldown_timer = cooldown

	return true


func _process(delta):
	if is_equipped and cooldown_timer > 0:
		cooldown_timer = max(cooldown_timer - delta, 0)
		if cooldown_timer == 0:
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
