# A tracker for the health of an entity.

class_name Health
extends Node

@export var base_max_health: int

var _max_health: int
var _current_health: int

signal before_damage(raw_amount)
signal on_damage(final_amount)
signal before_heal(raw_amount)
signal on_heal(final_amount)
signal on_death

func _init():
    _max_health = base_max_health
    _current_health = _max_health

func set_max_health(amount: int):
    _max_health = amount
    _current_health = clamp(_current_health, 0, _max_health)

func increment_max_health(amount: int):
    set_max_health(_max_health + amount)

func take_damage(amount: int):
    before_damage.emit(amount)

    # TODO: Compute the effect of all effects on this entity first
    var final_amount = amount

    _current_health = max(_current_health - final_amount, 0)
    on_damage.emit(final_amount)

    if _current_health == 0:
        on_death.emit()

func take_healing(amount: int):
    before_heal.emit(amount)

    # TODO: Compute the effect of all effects on this entity first
    var final_amount = amount

    _current_health = min(_current_health + final_amount, _max_health)
    on_heal.emit(final_amount)
