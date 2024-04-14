# Represents a group of slots for shop pickups that are purchased mutually exclusively.

class_name ShopGroup
extends Node2D

@export var restock_time: float
@export var base_cost: int

@export_category("Dependencies")
@export var slots: Array[Node2D]

var current_cost: int

var _restock_timer: float
var _bank: Bank


func _ready():
	current_cost = base_cost

	_restock()

	_bank.balance_changed.connect(_can_purchase)


func _process(delta):
	if _restock_timer > 0:
		_restock_timer = max(_restock_timer - delta, 0)
		if _restock_timer == 0:
			_restock()


func _can_purchase(balance: int) -> bool:
	return balance <= current_cost


func _restock():
	pass
