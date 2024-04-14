class_name LootChance
extends Resource

@export var drop: PackedScene
@export var base_chance: float


func chance():
	return clamp(base_chance, 0, 1)
