extends Node2D


@export var library: EquipmentLibrary
@export var item_spacing: float = 96
@export var max_row_count: int = 10
@export var respawn_interval: float = 2


var _respawn_timer: float = 0


func _ready():
	var spawn_pos = global_position
	var row_count = 0
	for equipment_type in library.equipment_types:
		_spawn_equipment(equipment_type, spawn_pos)
		spawn_pos.x += item_spacing
		row_count += 1 
		if row_count >= max_row_count:
			row_count = 0
			spawn_pos.y += item_spacing
			

func _spawn_equipment(equipment_type: String, spawn_pos: Vector2):
	var inst = library.spawn_dropped_equipment(equipment_type)
	var dropped_equipment = inst.get_node("EquipmentPickup") as EquipmentPickup
	dropped_equipment.picked_up.connect(_spawn_equipment.bind(equipment_type, spawn_pos))
	add_child(inst)
	inst.global_position = spawn_pos
