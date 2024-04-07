class_name WormBank
extends Node


signal money_changed(new_amount: int)

@export var starting_money: int

var money: int :
	get:
		return _money
	set(value):
		_money = value
		money_changed.emit(_money)

var _money: int


func _ready():
	money = starting_money