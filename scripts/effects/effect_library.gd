@icon("res://assets/art/editor_icons/icon_packed_data_container.svg")
class_name EffectLibrary
extends Resource


@export var effect_prefabs: Array[PackedScene]

# [Effect.Type]: PackedScene
var effect_prefabs_dict: Dictionary :
	get:
		if not _effect_prefabs_dict:
			_effect_prefabs_dict = {}
			for effect_prefab in effect_prefabs:
				var inst = effect_prefab.instantiate() as Effect
				_effect_prefabs_dict[inst.effect_type] = effect_prefab
				inst.queue_free()
		return _effect_prefabs_dict

var _effect_prefabs_dict: Dictionary


func force_init():
	var _empty = effect_prefabs_dict


func spawn_effect(effect_type: Effect.Type) -> Effect:
	return (effect_prefabs_dict[effect_type] as PackedScene).instantiate() as Effect
