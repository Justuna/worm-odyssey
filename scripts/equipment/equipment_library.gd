@icon("res://assets/art/editor_icons/icon_packed_data_container.svg")
extends Resource
class_name EquipmentLibrary


@export var equipment_prefabs: Array[PackedScene]
@export var dropped_equipment_prefab: PackedScene

# [Equipment.Type]: PackedScene
var equipment_prefabs_dict: Dictionary :
	get:
		if not _equipment_prefabs_dict:
			_equipment_prefabs_dict = {}
			for equipment_prefab in equipment_prefabs:
				var inst = equipment_prefab.instantiate() as Equipment
				_equipment_prefabs_dict[inst.equipment_type] = equipment_prefab
				inst.queue_free()
		return _equipment_prefabs_dict

var _equipment_prefabs_dict: Dictionary


func force_init():
	var _empty = equipment_prefabs_dict


func spawn_equipment(equipment_type: Equipment.Type) -> Equipment:
	return (equipment_prefabs_dict[equipment_type] as PackedScene).instantiate() as Equipment


func spawn_dropped_equipment(equipment_type: Equipment.Type) -> Node2D:
	var inst = dropped_equipment_prefab.instantiate()
	var dropped_equipment = inst.get_node("DroppedEquipment") as DroppedEquipment
	dropped_equipment.construct(spawn_equipment(equipment_type))
	return inst


func spawn_dropped_equipment_from_existing(equipment: Equipment) -> Node2D:
	var inst = dropped_equipment_prefab.instantiate()
	var dropped_equipment = inst.get_node("DroppedEquipment") as DroppedEquipment
	dropped_equipment.construct(equipment)
	return inst
