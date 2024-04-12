class_name StatOverrideModifier
extends StatModifier


var amount: int :
	get:
		return _amount
	set(value):
		_amount = value
		updated.emit()
var _amount: int


func _init(amount: int):
	_amount = amount


func modify_stat(base_amount: int, current_amount: int) -> int:
	return _amount
