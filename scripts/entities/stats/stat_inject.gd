@tool
@icon("res://assets/art/editor_icons/icon_file_list_red.svg")
extends Node
class_name StatInject


enum ScaleMode {
	ADD,
	MULTIPLY,
	ABSOLUTE_MULTIPLY,
	OVERRIDE,
}


@export var type: Stat.Type :
	get:
		return _type
	set(value):
		_type = value
		if Engine.is_editor_hint():
			var key = Stat.Type.find_key(type) as String
			name = key.to_pascal_case()
var _type: Stat.Type
@export var base_stat: Stat
@export var scale_factor: float
@export var scale_mode: ScaleMode

var stat_modifier: StatModifier


func _ready():
	match scale_mode:
		ScaleMode.ADD:
			stat_modifier = StatAddModifier.new(scale_factor * base_stat.amount)
		ScaleMode.MULTIPLY:
			stat_modifier = StatMultModifier.new(scale_factor * base_stat.amount)
		ScaleMode.ABSOLUTE_MULTIPLY:
			stat_modifier = StatAbsoluteMultModifier.new(scale_factor * base_stat.amount)
		ScaleMode.OVERRIDE:
			stat_modifier = StatOverrideModifier.new(scale_factor * base_stat.amount)
