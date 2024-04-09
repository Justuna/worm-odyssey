extends Node2D
class_name Projectile


@export var direction: Vector2
@export var rotate_to_direction: bool
@export_range(0, 360) var rotate_angle_offset: float = 90

@onready var stat_block: StatBlock = get_node("StatBlock")


func construct(_position: Vector2, _direction: Vector2, _team: String):
	direction = _direction
	if rotate_to_direction:
		global_rotation = direction.angle() + deg_to_rad(rotate_angle_offset)
	global_position = _position
	(get_node("Team") as Team).team = _team
