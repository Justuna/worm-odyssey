@icon("res://assets/art/editor_icons/icon_packed_data_container.svg")
class_name EnemyLibrary
extends Resource


@export var enemy_cards: Array[EnemyCard]

# [String (Enemy Type)]: EnemyCard
var enemy_cards_dict: Dictionary :
	get:
		library_init()
		return _enemy_cards_dict
var _enemy_cards_dict: Dictionary

var enemy_types: Array[String] :
	get:
		library_init()
		return _enemy_types
var _enemy_types: Array[String]


var library_inited: bool = false


func library_init():
	if library_inited:
		return
	library_inited = true
	_enemy_cards_dict = {}
	for card in enemy_cards:
		if card.name in _enemy_cards_dict:
			printerr("Enemy Library: Enemy with name %s already exists, is there a duplicate name?" % card.name)
		_enemy_cards_dict[card.name] = card
	_enemy_types = []
	_enemy_types.assign(_enemy_cards_dict.keys())