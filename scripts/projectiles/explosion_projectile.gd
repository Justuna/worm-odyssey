class_name ExplosionProjectile
extends Projectile


@export var explosion_color: Color


func _ready():
	%ExplosionParticles.self_modulate = explosion_color
