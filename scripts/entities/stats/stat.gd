@tool
@icon("res://assets/art/editor_icons/icon_file_list.svg")
extends Node
class_name Stat


enum Type {
	SPEED,
	MAX_HEALTH,
	REGEN,
	DEFENSE,
	RELOAD,
	DAMAGE,
	FIRE_DAMAGE,
	POISON_DAMAGE,
	ICE_DAMAGE,
	ELECTRIC_DAMAGE,
	EXPLOSIVE_DAMAGE,
	INCOMING_HEALING,
	ACTION_SPEED,
	RANGE
}

signal updated

@export var type: Type :
	get:
		return _type
	set(value):
		_type = value
		if Engine.is_editor_hint():
			var key = Type.find_key(type) as String
			name = key.to_pascal_case()
var _type: Type
var modifiers: Array[StatModifier] :
	get:
		var arr: Array[StatModifier] = []
		arr.assign(_modifiers_dict.keys())
		return arr

## Proxy stats forward calls to a source_stat.
## Proxy stats are the Stat children of a StatBlockProxy node.
var is_proxy_stat: bool :
	get:
		return get_parent() is StatBlockProxy
var source_stat: Stat

# [StatModifier]: null
var _modifiers_dict: Dictionary
var _prev_max_health: int

@export var base_amount: int

var amount: int


func _ready():
	if is_proxy_stat:
		var proxy = get_parent() as StatBlockProxy
		proxy.source_stat_block_changed.connect(_on_stat_block_proxy_updated)
	_update_amount()


func _on_stat_block_proxy_updated():
	var proxy = get_parent() as StatBlockProxy
	if source_stat:
		# Disconnect from old source_stat
		source_stat.updated.disconnect(_update_amount)
	if proxy.source_stat_block:
		# Connect to new source_stat
		source_stat = proxy.get_or_add_stat(type)
		source_stat.updated.connect(_update_amount)


func add_modifier(modifier: StatModifier):
	if source_stat:
		source_stat.add_modifier(modifier)
	else:
		_modifiers_dict[modifier] = null
		modifier.updated.connect(_update_amount)
		_update_amount()


func remove_modifier(modifier: StatModifier):
	if source_stat:
		source_stat.remove_modifier(modifier)
	else:
		if modifier in _modifiers_dict:
			_modifiers_dict.erase(modifier)
			modifier.updated.disconnect(_update_amount)
			_update_amount()


func clear_modifiers():
	if source_stat:
		source_stat.clear_modifiers()
	else:
		for modifier in _modifiers_dict:
			_modifiers_dict.erase(modifier)
			modifier.updated.disconnect(_update_amount)
		_update_amount()


func _update_amount():
	if source_stat:
		amount = source_stat.amount
	else:
		amount = base_amount
		for modifier: StatModifier in _modifiers_dict.keys():
			amount = modifier.modify_stat(base_amount, amount)
	updated.emit()
