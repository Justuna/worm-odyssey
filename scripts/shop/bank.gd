class_name Bank
extends Node


signal balance_changed(new_amount: int)

@export var starting_balance: int

var balance: int :
	get:
		return _balance
	set(value):
		_balance = value
		balance_changed.emit(_balance)

var _balance: int


func _ready():
	balance = starting_balance
