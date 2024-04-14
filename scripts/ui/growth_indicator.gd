class_name GrowthIndicator
extends Node


@export var worm: Node2D
@export var growth_indicator: Sprite2D
	
var _meter: GrowthMeter


# Called when the node enters the scene tree for the first time.
func _ready():
	growth_indicator.material = growth_indicator.material.duplicate()
	_meter = worm.get_node_or_null("GrowthMeter") as GrowthMeter
	
	
func _process(_delta):
	if _meter:
		_set_indicator(_meter.growth_meter.value / _meter.growth_requirement)


func _set_indicator(factor: float):
	factor = clamp(factor, 0, 1)
	(growth_indicator.material as ShaderMaterial).set_shader_parameter("fill_amount", factor)
