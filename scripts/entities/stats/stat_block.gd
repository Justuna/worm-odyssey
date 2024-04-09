@icon("res://assets/art/editor_icons/icon_packed_data_container.svg")
class_name StatBlock
extends Node


# [Stat.Type]: Stat
var stats_dict: Dictionary


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
