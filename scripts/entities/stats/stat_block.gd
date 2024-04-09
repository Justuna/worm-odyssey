@icon("res://assets/art/editor_icons/icon_packed_data_container.svg")
extends Node
class_name StatBlock


# [Stat.Type]: Stat
var stats_dict: Dictionary
## Syncs the modifiers in this stat
## block to the sync_modifiers_stat_block
var sync_modifiers_stat_block: StatBlock :
	get:
		return _sync_modifiers_stat_block
	set(value):
		if _sync_modifiers_stat_block:
			# Desync with old stat block
			for stat_type in stats_dict:
				var stat = stats_dict[stat_type] as Stat
				stat.synced_stat = null
		_sync_modifiers_stat_block = value
		if _sync_modifiers_stat_block:
			# Sync with new stat block
			for stat_type in stats_dict:
				var stat = stats_dict[stat_type] as Stat
				var synced_stat = _sync_modifiers_stat_block.get_stat(stat_type)
				stat.synced_stat = synced_stat
var _sync_modifiers_stat_block: StatBlock


func _ready():
	stats_dict = {}
	for child in get_children():
		if child is Stat:
			stats_dict[child.type] = child


func get_or_add_stat(type: Stat.Type) -> Stat:
	var stat = get_stat(type)
	if not stat:
		stat = Stat.new()
		stats_dict[type] = stat
		add_child(stat)
	return stat


func get_stat(type: Stat.Type) -> Stat:
	if type in stats_dict:
		return stats_dict[type]
	return null


func get_stat_amount(type: Stat.Type) -> int:
	if type in stats_dict:
		return stats_dict[type].amount
	return 0


func set_stat_amount(type: Stat.Type, amount: int) -> bool:
	if type in stats_dict:
		stats_dict[type] = amount
		return true
	return false


func clear_modifiers():
	for type in stats_dict.keys():
		var stat = stats_dict[type] as Stat
		stat.clear_modifiers()
