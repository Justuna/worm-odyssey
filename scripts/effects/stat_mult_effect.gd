## Adds to a stat by a percentage amount
class_name StatMultEffect
extends Effect


@export var type: Stat.Type
@export_range(0.0, 1.0) var per_stack_percent: float

var _modifier: StatMultModifier = StatMultModifier.new(0)


func _on_add():
	_get_holder_stat(Stat.Type.REGEN).add_modifier(_modifier)


func _on_stack_changed():
	_modifier.percent = stack_amount * per_stack_percent


func _on_remove():
	_get_holder_stat(Stat.Type.REGEN).remove_modifier(_modifier)
