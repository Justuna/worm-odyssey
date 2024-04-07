extends Node2D


@export var spawned_equipment_count: int = 32

@export_category("Dependencies")
@export var equipment_library: EquipmentLibrary
@export var equipment_spawn_area: RectangleShape2D
@export var worm: Node2D

@onready var worm_controller: WormController = worm.get_node("WormController") as WormController


func _ready():
	var spawn_rect = equipment_spawn_area.get_rect()
	for i in range(spawned_equipment_count):
		var rand_point = Vector2(randf_range(spawn_rect.position.x, spawn_rect.end.x), randf_range(spawn_rect.position.y, spawn_rect.end.y))
		var rand_type = randi_range(0, Equipment.Type.keys().size() - 1) as Equipment.Type
		var dropped_inst = equipment_library.spawn_dropped_equipment(rand_type)
		add_child(dropped_inst)
		dropped_inst.global_position = rand_point


func _input(event):
	if event is InputEventKey:
		if not event.pressed:
			match event.keycode:
				KEY_G:
					if is_instance_valid(worm_controller):
						worm_controller.grow()
				KEY_B:
					if is_instance_valid(worm_controller):
						(worm_controller.segments[0].get_node("Health") as Health).take_damage(50)
				KEY_D:
					if is_instance_valid(worm_controller):
						worm_controller.debug_draw = not worm_controller.debug_draw
