class_name HitIndicatorSpawner
extends Node2D


@export var hit_indicator_prefab: PackedScene
@export var jitter: Vector2
@export var healing_color: Color
@export var damage_color: Color

static var instance: HitIndicatorSpawner:
	get:
		return _instance
static var _instance: HitIndicatorSpawner


func _enter_tree():
	if instance:
		queue_free()
		return
	_instance = self


func indicate_hit(amount: int, position: Vector2, is_healing: bool):
	var hit_indicator = hit_indicator_prefab.instantiate() as HitIndicator
	if hit_indicator:
		var offset_x = randf_range(-jitter.x, jitter.x)
		var offset_y = randf_range(-jitter.y, jitter.y)

		add_child(hit_indicator)
		hit_indicator.position = Vector2(position.x + offset_x, position.y + offset_y)
		hit_indicator.construct(amount, healing_color if is_healing else damage_color)
