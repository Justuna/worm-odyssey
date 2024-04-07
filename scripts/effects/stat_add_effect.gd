## Adds to a stat by a fixed amount
class_name StatAddEffect
extends Effect


@export var type: Stat.Type
@export var per_stack_amount: int

var _modifier: StatAddModifier = StatAddModifier.new(0)


func _on_add():
	_get_holder_stat(Stat.Type.REGEN).add_modifier(_modifier)


func _on_stack_changed():
	_modifier.amount = stack_amount * per_stack_amount


func _on_remove():
	_get_holder_stat(Stat.Type.REGEN).remove_modifier(_modifier)
