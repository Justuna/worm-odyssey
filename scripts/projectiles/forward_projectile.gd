class_name ForwardProjectile
extends Node


const SPEED_FACTOR: float = 4

@export var speed_stat: Stat

@onready var projectile: Projectile = get_parent() as Projectile


func _process(delta):
	get_parent().global_position += speed_stat.amount * SPEED_FACTOR * projectile.direction * delta
