class_name LootTable
extends Node


@export var money_drop_inflation: Economy
@export var money_drop_prefab: PackedScene
@export var spawners: Array[Spawner]
@export var drop_table: Array[LootChance]
@export var jitter: Vector2

func _ready():
	for spawner in spawners:
		spawner.before_place_enemy.connect(_attach_loot_tracker)


func _attach_loot_tracker(enemy: Node):
	var money_drop = money_drop_prefab.instantiate()
	var money_pickup = money_drop.get_node_or_null("MoneyPickup") as MoneyPickup
	if money_pickup:
		money_pickup.construct(floor(money_drop_inflation.value))

	var loot_tracker = LootTracker.new()
	loot_tracker.loot.push_back(money_drop)
	loot_tracker.jitter = jitter
	
	for drop_chance in drop_table:
		var f = randf_range(0, 1)
		if f <= drop_chance.chance():
			print("Adding loot...")
			var drop = drop_chance.drop.instantiate()
			print("Spawned with %s" % drop.name)
			loot_tracker.loot.push_back(drop)

	enemy.add_child(loot_tracker)
