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
	EXPLOSIVE_DAMGE,
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
# [StatModifier]: null
var _modifiers_dict: Dictionary
var _prev_max_health: int

@export var base_amount: int

var amount: int


func _ready():
	_update_amount()


func add_modifier(modifier: StatModifier):
	_modifiers_dict[modifier] = null
	modifier.updated.connect(_update_amount)


func remove_modifier(modifier: StatModifier):
	if modifier in _modifiers_dict:
		_modifiers_dict.erase(modifier)
		modifier.updated.disconnect(_update_amount)


func _update_amount():
	amount = base_amount
	updated.emit()
	for modifier: StatModifier in _modifiers_dict.keys():
		amount = modifier.modify_stat(base_amount, amount)
