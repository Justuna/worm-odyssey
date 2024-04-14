class_name HitTaker
extends Node

@export var health: Health
@export var hurtbox: HitDetector

@export var multiplier = 1


func route_damage_inst(damage_inst: DamageInstance, can_crit: bool = true):
	if not damage_inst.is_healing and can_crit:
		var amount = damage_inst.amount
		damage_inst.additional_amount = max(amount * multiplier, amount) - amount
	health.take_damage_inst(damage_inst)


func route_healing(amount: int):
	health.take_healing(amount)


func route_damage(amount: int, can_crit = true):
	if can_crit:
		amount *= multiplier
	
	health.take_damage(amount)
