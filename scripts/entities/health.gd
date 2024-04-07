# A tracker for the health of an entity.

class_name Health
extends Node


signal before_damage(raw_amount: int)
signal on_damage(final_amount: int)
signal before_heal(raw_amount: int)
signal on_heal(final_amount: int)
signal on_health_changed(final_amount: int)
signal on_death

@export var max_health: Stat

var health: int

var _prev_max_health: int


func _ready():
	health = max_health.amount
	_prev_max_health = max_health.amount
	max_health.updated.connect(_on_max_health_updated)

func take_damage(amount: int):
	before_damage.emit(amount)

	# TODO: Compute the effect of all effects on this entity first
	var final_amount = amount

	health = max(health - final_amount, 0)
	on_damage.emit(final_amount)
	on_health_changed.emit(-final_amount)

	if health == 0:
		on_death.emit()

func take_healing(amount: int):
	before_heal.emit(amount)

	# TODO: Compute the effect of all effects on this entity first
	var final_amount = amount

	health = min(health + final_amount, max_health.amount)
	on_heal.emit(final_amount)
	on_health_changed.emit(final_amount)


func _on_max_health_updated():
	# Scale health to max health by percentage of health to previous max health
	health = roundi(max_health.amount * (float(health) / _prev_max_health))
	_prev_max_health = max_health.amount
