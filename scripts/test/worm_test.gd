@tool
extends Node2D


@export var spawned_equipment_count: int = 32
@export var spawned_enemy_count: int = 8

@export_category("Dependencies")
@export var equipment_library: EquipmentLibrary
@export var enemy_library: EnemyLibrary
@export var spawn_area: RectangleShape2D
@export var worm: Node2D

@onready var worm_controller: WormController = worm.get_node("WormController") as WormController


func _ready():
	if Engine.is_editor_hint():
		return
	var spawn_rect = spawn_area.get_rect()
	for i in range(spawned_equipment_count):
		var rand_point = Vector2(randf_range(spawn_rect.position.x, spawn_rect.end.x), randf_range(spawn_rect.position.y, spawn_rect.end.y))
		var rand_type = equipment_library.equipment_types.pick_random()
		var dropped_inst = equipment_library.spawn_dropped_equipment(rand_type)
		add_child(dropped_inst)
		dropped_inst.global_position = rand_point


func _process(delta):
	queue_redraw()


func _draw():
	draw_rect(spawn_area.get_rect(), Color.RED, false)
	draw_rect(spawn_area.get_rect(), Color(Color.RED, 0.2), true)


func _input(event):
	if Engine.is_editor_hint():
		return
	if event is InputEventKey:
		if not event.pressed:
			match event.keycode:
				KEY_G:
					if is_instance_valid(worm_controller):
						worm_controller.grow()
				KEY_B:
					if is_instance_valid(worm_controller):
						(worm_controller.segments[0].get_node("Health") as Health).take_damage(50)
						if worm_controller.segments.size() > 2:
							(worm_controller.segments[2].get_node("Health") as Health).take_damage(50)
				KEY_D:
					if is_instance_valid(worm_controller):
						worm_controller.debug_draw = not worm_controller.debug_draw
				KEY_S:
					var spawn_rect = spawn_area.get_rect()
					for i in range(spawned_enemy_count):
						var rand_point = Vector2(randf_range(spawn_rect.position.x, spawn_rect.end.x), randf_range(spawn_rect.position.y, spawn_rect.end.y))
						var rand_type = enemy_library.enemy_types.pick_random()
						var enemy_inst = enemy_library.spawn_enemy(rand_type)
						add_child(enemy_inst)
						enemy_inst.global_position = rand_point
