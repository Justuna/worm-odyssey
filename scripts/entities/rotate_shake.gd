extends Node

@export var target: Node2D
@export var stiffness: float = 100
@export var friction: float = 2
@export var velocity_limit: float = 1000
@export var shake_amount: float = 200

var _shake_tween: Tween
var _shake_velocity_deg: float


func shake():
	_shake_velocity_deg += shake_amount
	_shake_velocity_deg = clamp(_shake_velocity_deg, -velocity_limit, velocity_limit)


func _process(delta):
	_shake_velocity_deg -= delta * (stiffness * rad_to_deg(target.global_rotation) + friction * _shake_velocity_deg)
	target.global_rotation += delta * deg_to_rad(_shake_velocity_deg)
