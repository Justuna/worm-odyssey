@icon("res://assets/art/editor_icons/icon_packed_data_container.svg")
class_name EquipmentLibrary
extends Resource


@export var equipment_prefabs: Array[PackedScene]
@export var dropped_equipment_prefab: PackedScene

# [String (Equipment Type)]: PackedScene
var equipment_prefabs_dict: Dictionary :
	get:
		library_init()
		return _equipment_prefabs_dict
var _equipment_prefabs_dict: Dictionary

var equipment_types: Array[String] :
	get:
		library_init()
		return _equipment_types
var _equipment_types: Array[String]

var library_inited: bool = false


func library_init():
	if library_inited:
		return
	library_inited = true
	_equipment_prefabs_dict = {}
	for equipment_prefab in equipment_prefabs:
		var inst = equipment_prefab.instantiate()
		if inst.name in _equipment_prefabs_dict:
			printerr("Enemy Library: Enemy with name %s already exists, is there a duplicate name?" % inst.name)
		_equipment_prefabs_dict[inst.name] = equipment_prefab
		inst.queue_free()
	_equipment_types = []
	_equipment_types.assign(_equipment_prefabs_dict.keys())


func spawn_equipment(equipment_type: String) -> Equipment:
	return (equipment_prefabs_dict[equipment_type] as PackedScene).instantiate() as Equipment


func spawn_dropped_equipment(equipment_type: String) -> Node2D:
	var inst = dropped_equipment_prefab.instantiate()
	var dropped_equipment = inst.get_node("EquipmentPickup") as EquipmentPickup
	dropped_equipment.construct(spawn_equipment(equipment_type))
	return inst


func spawn_dropped_equipment_from_existing(equipment: Equipment) -> Node2D:
	var inst = dropped_equipment_prefab.instantiate()
	var dropped_equipment = inst.get_node("EquipmentPickup") as EquipmentPickup
	dropped_equipment.construct(equipment)
	return inst
