class_name HomingProjectile
extends Node2D


const SPEED_FACTOR: float = 4

@export var enabled: bool = true :
	get:
		return _enabled
	set(value):
		_enabled = value
		if is_inside_tree():
			set_process(value)
var _enabled: bool = true
@export var speed_stat: Stat
@export var entity_tracker: EntityTracker
@export var rotation_speed_factor: float
@export var rotate_projectile: bool
@export var rotate_projectile_offset: float = 90

@onready var projectile: Projectile = get_parent() as Projectile


func _ready():
	enabled = enabled


func set_enabled(_enabled: bool):
	enabled = _enabled


func _process(delta):
	if entity_tracker.target_entity:
		var dir_to_target = (entity_tracker.target_entity.global_position - projectile.global_position)
		var angle_to_target = projectile.direction.angle_to(dir_to_target)
		var rot_amount = deg_to_rad(rotation_speed_factor * speed_stat.amount * SPEED_FACTOR) * delta
		if abs(angle_to_target) < abs(rot_amount):
			rot_amount = angle_to_target
		projectile.direction = projectile.direction.rotated(rot_amount)
	if rotate_projectile:
		projectile.global_rotation = projectile.direction.angle() + deg_to_rad(rotate_projectile_offset)
