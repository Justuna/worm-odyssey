extends Node2D


@export var spawned_equipment_count: int = 32

@export_category("Dependencies")
@export var equipment_library: EquipmentLibrary
@export var equipment_spawn_area: RectangleShape2D


func _ready():
	var spawn_rect = equipment_spawn_area.get_rect()
	for i in range(spawned_equipment_count):
		var rand_point = Vector2(randf_range(spawn_rect.position.x, spawn_rect.end.x), randf_range(spawn_rect.position.y, spawn_rect.end.y))
		var rand_type = randi_range(0, Equipment.Type.keys().size() - 1) as Equipment.Type
		var dropped_inst = equipment_library.spawn_dropped_equipment(rand_type)
		add_child(dropped_inst)
		dropped_inst.global_position = rand_point
