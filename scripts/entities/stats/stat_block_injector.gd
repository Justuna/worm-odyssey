## Container for StatInjects
## Injects values into prefab's stat blocks
@icon("res://assets/art/editor_icons/icon_packed_data_container_red.svg")
class_name StatBlockInjector
extends Node


func inject_stats(node: Node):
	var stat_block = node.get_node("StatBlock") as StatBlock
	for stat_inject in get_children():
		if stat_inject is StatInject:
			var base_stat = stat_inject.base_stat as Stat
			var stat = stat_block.get_or_add_stat(stat_inject.type) 
			stat.add_modifier(stat_inject.stat_modifier)
