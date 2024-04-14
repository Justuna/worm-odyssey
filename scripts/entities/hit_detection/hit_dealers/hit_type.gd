## Base class for entities who can damage/heal other entities on contact.
class_name HitType
extends Node


signal hit_dealt(node: Node)


@export var hitbox: HitDetector

@export var damage_inst: DamageInstance
@export var damage_inst_multiplier: float = 1.0

@export var is_healing: bool
@export var can_crit: bool
@export var effects: Array[Effect.Type]


func reset_damage_inst():
	damage_inst.reset()
	var amount = damage_inst.amount 
	damage_inst.additional_amount = max(amount * damage_inst_multiplier - amount, 0)
