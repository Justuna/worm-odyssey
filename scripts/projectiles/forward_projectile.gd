class_name ForwardProjectile
extends Node


@export var speed_stat: Stat

@onready var projectile: Projectile = get_parent() as Projectile


func _process(delta):
	get_parent().global_position += speed_stat.amount * projectile.direction * delta
