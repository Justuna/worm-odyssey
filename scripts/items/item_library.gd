@icon("res://assets/art/editor_icons/icon_packed_data_container.svg")
class_name ItemLibrary
extends Resource


@export var item_prefabs: Array[PackedScene]

# [Item.Type]: PackedScene
var item_prefabs_dict: Dictionary :
	get:
		if not _item_prefabs_dict:
			_item_prefabs_dict = {}
			for item_prefab in item_prefabs:
				var inst = item_prefab.instantiate() as Item
				_item_prefabs_dict[inst.item_type] = item_prefab
				inst.queue_free()
		return _item_prefabs_dict

var _item_prefabs_dict: Dictionary


func force_init():
	var _empty = item_prefabs_dict


func spawn_item(item_type: Item.Type) -> Item:
	return (item_prefabs_dict[item_type] as PackedScene).instantiate() as Item
