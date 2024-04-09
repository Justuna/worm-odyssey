@tool
class_name RangeCollisionShape2D
extends CollisionShape2D


const RANGE_FACTOR: float = 8


@export var range: Stat


func _ready():
	set_process(Engine.is_editor_hint())
	if Engine.is_editor_hint():
		return
	range.updated.connect(_on_range_updated)


func _on_range_updated():
	if shape:
		if shape is CircleShape2D:
			shape.radius = range.amount * RANGE_FACTOR


func _process(delta):
	if range and shape:
		if shape is CircleShape2D:
			shape.radius = range.base_amount * RANGE_FACTOR
