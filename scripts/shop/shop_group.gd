# Represents a group of slots for shop pickups that are purchased mutually exclusively.

class_name ShopGroup
extends Node2D

@export var restock_time: float
@export var base_cost: int

@export_category("Dependencies")
@export var worm: Node
@export var slots: Array[Node2D]

var current_cost: int

var _restock_timer: float
var _bank: Bank


func _ready():
	current_cost = base_cost
	_bank = worm.get_node_or_null("Bank")

	_restock()

	_bank.balance_changed.connect(_can_purchase)


func _process(delta):
	if _restock_timer > 0:
		_restock_timer = max(_restock_timer - delta, 0)
		if _restock_timer == 0:
			_restock()


func _can_purchase(balance: int):
	print("Seeing if available")
	if balance >= current_cost:
		_make_available()
	else:
		_make_unavailable()


func _make_available():
	print("Can afford this shop")


func _make_unavailable():
	print("Cannot afford this shop")


func _restock():
	_can_purchase(_bank.balance)
