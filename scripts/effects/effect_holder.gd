@icon("res://assets/art/editor_icons/icon_file_list.svg")
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
		add_child(effect)
	effect.stack_amount += 1
	effect._on_stack()
	effect._on_stack_changed()


func get_effect(effect_type: Effect.Type) -> Effect:
	return effects.get(effect_type)


func remove_effect(effect_type: Effect.Type):
	var effect = get_effect(effect_type)
	if effect:
		effect._on_unstack()
		effect._on_stack_changed()
		effect.stack_amount -= 1
		if effect.stack_amount == 0:
			effects.erase(effect.effect_type)
			effect._on_remove()
			effect.queue_free()


func clear_effects():
	for effect_type in effects.keys():
		var effect = effects[effect_type]
		effects.erase(effect_type)
		effect._on_remove()
		effect.queue_free()
