## Base class for entities who can damage/heal other entities on contact.
class_name HitType
extends Node


signal hit_dealt(node: Node)


@export var hitbox: HitDetector

@export var amount_stat: Stat
@export var amount_stat_multiplier: float = 1.0

var amount: int :
	get:
		return round(amount_stat.amount * amount_stat_multiplier)

@export var is_healing: bool
@export var can_crit: bool
@export var effects: Array[Effect.Type]
