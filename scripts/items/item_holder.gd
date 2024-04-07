@icon("res://assets/art/editor_icons/icon_file_list.svg")

class_name ItemHolder
extends Node


@export var item_library: ItemLibrary
@export var effect_holder: EffectHolder

# [Item.Type]: Item
var items: Dictionary
var target : Node :
	get:
		return get_parent()


func add_item(item_type: Item.Type):
	var item = get_item(item_type)
	if not item:
		item = item_library.spawn_item(item_type)
		items[item_type] = item
		item.item_holder = self
		item._on_add()
	item.stack_amount += 1
	item._on_stack()
	item._on_stack_changed()


func get_item(item_type: Item.Type) -> Item:
	return items[item_type]


func remove_item(item_type: Item.Type):
	var item = get_item(item_type)
	if item:
		item._on_unstack()
		item._on_stack_changed()
		item.stack_amount -= 1
		if item.stack_amount == 0:
			items[item.type] = null
			item._on_remove()
