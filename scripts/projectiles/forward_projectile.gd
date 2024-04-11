class_name ForwardProjectile
extends Node


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

@onready var projectile: Projectile = get_parent() as Projectile


func _ready():
	enabled = enabled


func set_enabled(_enabled: bool):
	enabled = _enabled


func _process(delta):
	get_parent().global_position += speed_stat.amount * SPEED_FACTOR * projectile.direction * delta
