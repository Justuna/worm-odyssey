class_name EnemyLibrary
extends Resource


@export var enemy_prefabs: Array[PackedScene]

# [String (Enemy Type)]: EnemyCard
var enemy_prefabs_dict: Dictionary :
	get:
		library_init()
		return _enemy_prefabs_dict
var _enemy_prefabs_dict: Dictionary

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
	_enemy_prefabs_dict = {}
	for prefab in enemy_prefabs:
		if prefab.name in _enemy_prefabs_dict:
			printerr("Enemy Library: Enemy with name %s already exists, is there a duplicate name?" % prefab.name)
		_enemy_prefabs_dict[prefab.name] = prefab
	_enemy_types = []
	_enemy_types.assign(_enemy_prefabs_dict.keys())


func spawn_enemy(enemy_type: String) -> Node2D:
	return (enemy_prefabs_dict[enemy_type] as PackedScene).instantiate() as Node2D
