## Used to keep track of an instance 
## of damage or heal.
class_name DamageInstance
extends Node


const MULTIPLIER_SCALE: float = 1 / 100.0

@export var base_stat: Stat
@export var mult_stats: Array[Stat]
@export var is_healing: bool
@export var team: Team

var base_amount: int :
	get:
		var total_mult = 1.0
		for stat in mult_stats:
			total_mult += stat.amount * MULTIPLIER_SCALE
		total_mult = max(0, total_mult)
		var amount = ceil(base_stat.amount * total_mult)
		return amount
## Used by effects to modify the damage when a damage notification is sent
var additional_amount: int
var amount: int:
	get:
		return base_amount + additional_amount


func notify_pre_damage(health: Health):
	if is_instance_valid(team.entity_owner):
		var listener = team.entity_owner.get_node_or_null("DamageInstanceListener") as DamageInstanceListener
		if listener:
			listener.notify_pre_damage(self, health)


func notify_post_damage(health: Health):
	if is_instance_valid(team.entity_owner):
		var listener = team.entity_owner.get_node_or_null("DamageInstanceListener") as DamageInstanceListener
		if listener:
			listener.notify_post_damage(self, health)


func reset():
	additional_amount = 0
