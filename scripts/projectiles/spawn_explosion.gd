class_name SpawnExplosion
extends Node2D


@export var team: Team
@export var explosion_prefabs: Array[PackedScene]
@export var stat_block_injector: StatBlockInjector


func _ready():
	if Engine.is_editor_hint():
		return
		

func spawn_projectiles():
	for prefab in explosion_prefabs:
		var inst = prefab.instantiate() as ExplosionProjectile
		if inst:
			World.instance.add_child(inst)
			stat_block_injector.inject_stats(inst)
			inst.construct(global_position, Vector2.ZERO, team)
