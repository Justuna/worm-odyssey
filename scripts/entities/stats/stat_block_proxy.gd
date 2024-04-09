## Redirects all calls to a source_stat_block
##
## Primarily used in equipments
@icon("res://assets/art/editor_icons/icon_packed_data_container.svg")
class_name StatBlockProxy
extends StatBlock


signal source_stat_block_changed

@export var source_stat_block: StatBlock :
	get:
		return _source_stat_block
	set(value):
		if value != self:
			_source_stat_block = value
			source_stat_block_changed.emit()
var _source_stat_block: StatBlock


func _ready():
	pass


func get_or_add_stat(type: Stat.Type) -> Stat:
	return source_stat_block.get_or_add_stat(type)


func get_stat(type: Stat.Type) -> Stat:
	return source_stat_block.get_stat(type)


func get_stat_amount(type: Stat.Type) -> int:
	return source_stat_block.get_stat_amount(type)


func set_stat_amount(type: Stat.Type, amount: int) -> bool:
	return source_stat_block.set_stat_amount(type, amount)


func clear_modifiers():
	return source_stat_block.clear_modifiers()
