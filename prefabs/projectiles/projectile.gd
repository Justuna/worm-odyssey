extends Node2D
class_name Projectile


@export var direction: Vector2
@export var rotate_to_direction: bool

var stat_block: StatBlock :
	get:
		return get_node("StatBlock")


func construct(_position: Vector2, _direction: Vector2):
	direction = _direction
	if rotate_to_direction:
		global_rotation = direction.angle()
	global_position = _position
