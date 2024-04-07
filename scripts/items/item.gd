# Base class for items.

class_name Item
extends Node2D


enum Type {
	ALOE_VERA,
	BATTERY,
	BLAHAJ,
	BOBA_TEA,
	BOGO_COUPON,
	BUG_SPRAY,
	GASOLINE,
	GUNPOWDER,
	HELMET,
	ICE_PACK,
	JUMP_ROPE,
	PORTABLE_RADAR,
	REACTANT,
	READING_GLASSES,
	REVERSE_CARD,
	RUBBER_BAND,
	SICK_BAG,
	SLINGSHOT,
	SNAKE_OIL,
	SPITBALL,
	STOCK_OPTIONS,
	STOP_WATCH,
	TAR_AND_FEATHERS,
	TIP_JAR,
	UNDERWEAR,
	WHISTLE,
	WINDMILL,
}


@export var effects: Array[Effect.Type]
@export var type: Type

var item_holder: ItemHolder


## Called when the item is added.
## Is not called on repeated stacking of the item.
func _on_add():
	pass


## Called every time the item is stacked/unstacked
func _on_stack_changed():
	pass


## Called every time the item is stacked.
func _on_stack():
	for effect in effects:
		item_holder.effect_holder.add_effect(effect)

## Called every time the item is unstacked.
func _on_unstack():
	for effect in effects:
		item_holder.effect_holder.remove_effect(effect)

## Called when the item is remove.
## Is not called on repeated unstacking of the item.
func _on_remove():
	pass