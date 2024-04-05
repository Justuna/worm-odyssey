extends Node2D
class_name Equipment


enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}


signal active_used
# Worm that the equipment is attached to
var worm: Node2D
# WormSegment that the equipment is attached to
var segment: WormSegment
# Direction of the equipment
var direction: Direction


func construct(_worm: Node2D, _segment: WormSegment, _direction: Direction):
	worm = _worm
	segment = _segment
	direction = _direction


func use_active():
	active_used.emit()
