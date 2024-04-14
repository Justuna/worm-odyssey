## Base class for all effects
extends Node
class_name Effect

enum Type {
	ALOE_VERA,
	DURABLE,
	FIRE
}

@export var effect_type: Type 
var stack_amount: int = 0

# set by EffectHolder
var effect_holder: EffectHolder

## Called when the effect is added.
## Is not called on repeated stacking of the effect.
func _on_add():
	pass


## Called every time the effect is stacked/unstacked
func _on_stack_changed():
	pass


## Called every time the effect is stacked.
func _on_stack():
	pass

## Called every time the effect is unstacked.
func _on_unstack():
	pass

## Called when the effect is remove.
## Is not called on repeated unstacking of the effect.
func _on_remove():
	pass


func _get_holder_stat(stat: Stat.Type) -> Stat:
	return (effect_holder.target.get_node("StatBlock") as StatBlock).get_stat(stat)
