@icon("res://assets/art/editor_icons/icon_packed_data_container.svg")
extends Node
class_name StatBlock


# [Stat.Type]: Stat
var stats_dict: Dictionary


func _ready():
	stats_dict = {}
	for child in get_children():
		if child is Stat:
			stats_dict[child.type] = child


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
