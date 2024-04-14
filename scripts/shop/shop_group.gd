# Represents a group of slots for shop pickups that are purchased mutually exclusively.

class_name ShopGroup
extends Node2D

@export var restock_time: float
@export var use_children_as_slots: bool = true
@export var price_multiplier: float = 1

@export_category("Dependencies")
@export var slots: Array[Node2D]
@export var cost_label: Label

var current_cost: int

var _restock_timer: float


func _ready():
	if use_children_as_slots:
		for child in get_children():
			if child is Node2D and not slots.has(child):
				slots.append(child)
	_restock()


func _process(delta):
	if _restock_timer > 0:
		_restock_timer = max(_restock_timer - delta, 0)
		if _restock_timer == 0:
			_restock()


func _can_purchase(interactor: Interactor) -> bool:
	var bank = interactor.get_parent().get_node_or_null("Bank") as Bank
	if bank:
		return bank.balance >= current_cost
	return false


func _restock():
	current_cost = ceil(World.instance.shop_inflation.value) * price_multiplier
	cost_label.text = "$" + str(current_cost)
