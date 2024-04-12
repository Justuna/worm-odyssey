class_name SpawnProjectile
extends Node2D


@export var base_projectile: Projectile
@export var projectile_prefabs: Array[PackedScene]
@export var projectile_nodes: Array[Projectile]
@export var use_children_projectiles: bool = true
@export var stat_block_injector: StatBlockInjector


func _ready():
	if Engine.is_editor_hint():
		return
	if use_children_projectiles:
		for child in get_children():
			if child is Projectile and not projectile_nodes.has(child):
				projectile_nodes.append(child)


func spawn_projectiles():
	for node in projectile_nodes:
		stat_block_injector.inject_stats(node)
		node.reparent.call_deferred(World.instance, true)
		node.construct.call_deferred(node.global_position, base_projectile.direction, base_projectile.team.team)
	for prefab in projectile_prefabs:
		var inst = prefab.instantiate() as Projectile
		World.instance.add_child(inst)
		stat_block_injector.inject_stats(inst)
		inst.construct(global_position, base_projectile.direction, base_projectile.team.team)
