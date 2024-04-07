## Aloe Vera: Item that increases regen after a short duration out of combat.
class_name AloeVeraEffect
extends Effect


const ALOE_VERA_STACK_MODIFIER = 0.1
const ALOE_VERA_TIMER = 2

var modifier: float :
	get:
		return stack_amount * ALOE_VERA_STACK_MODIFIER
var active = true
var _timer: float = 0

var _modifier: StatAddModifier = StatAddModifier.new(0)


func _on_add():
	(effect_holder.target.get_node("Health") as Health).on_damage.connect(_deactivate)
	_get_holder_stat(Stat.Type.REGEN).add_modifier(_modifier)


func _on_stack_changed():
	_modifier.amount = stack_amount * ALOE_VERA_STACK_MODIFIER


func _on_remove():
	(effect_holder.target.get_node("Health") as Health).on_damage.disconnect(_deactivate)
	_get_holder_stat(Stat.Type.REGEN).remove_modifier(_modifier)


func _process(delta):
	if _timer > 0:
		_timer -= delta
		if _timer <= 0:
			_get_holder_stat(Stat.Type.REGEN).add_modifier(_modifier)
			active = true


func _deactivate():
	active = false
	_timer = ALOE_VERA_TIMER
	_get_holder_stat(Stat.Type.REGEN).remove_modifier(_modifier)
