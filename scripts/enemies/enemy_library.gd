@icon("res://assets/art/editor_icons/icon_packed_data_container.svg")
class_name EnemyLibrary
extends Resource


@export var enemy_prefabs: Array[PackedScene]

# [String (Enemy Type)]: PackedScene
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
	for enemy_prefab in enemy_prefabs:
		var inst = enemy_prefab.instantiate()
		if inst.name in _enemy_prefabs_dict:
			printerr("Enemy Library: Enemy with name %s already exists, is there a duplicate name?" % inst.name)
		_enemy_prefabs_dict[inst.name] = enemy_prefab
		inst.queue_free()
	_enemy_types = []
	_enemy_types.assign(_enemy_prefabs_dict.keys())


func spawn_enemy(enemy_type: String, team: String = "Enemy") -> Node2D:
	var enemy = (enemy_prefabs_dict[enemy_type] as PackedScene).instantiate()
	(enemy.get_node("Team") as Team).team = team
	return enemy
