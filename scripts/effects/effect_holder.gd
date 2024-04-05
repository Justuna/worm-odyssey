extends Node
class_name EffectHolder


@export var effect_library: EffectLibrary

# [Effect.Type]: Effect
var effects: Dictionary
var target : Node :
	get:
		return get_parent()


func add_effect(effect_type: Effect.Type):
	var effect = get_effect(effect_type)
	if not effect:
		effect = effect_library.spawn_effect(effect_type)
		effects[effect_type] = effect
		effect.effect_holder = self
		effect._on_add()
	effect.stack_amount += 1
	effect._on_stack()


func get_effect(effect_type: Effect.Type) -> Effect:
	return effects[effect_type]


func remove_effect(effect_type: Effect.Type):
	var effect = get_effect(effect_type)
	if effect:
		effect._on_unstack()
		effect.stack_amount -= 1
		if effect.stack_amount == 0:
			effects[effect.type] = null
			effect._on_remove()
