class_name HitTaker
extends Node

@export var health: Health
@export var hurtbox: HitDetector

@export var multiplier = 1

func route_healing(amount: int):
    health.take_healing(amount)

func route_damage(amount: int, can_crit = true):
    if can_crit:
        amount *= multiplier
    
    health.take_damage(amount)