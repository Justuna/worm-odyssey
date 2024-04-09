class_name StatAbsoluteMultModifier
extends StatModifier


var percent: float :
	get:
		return _percent
	set(value):
		_percent = value
		updated.emit()
var _percent: float


func _init(percent: float):
	_percent = percent


func modify_stat(base_amount: int, current_amount: int) -> int:
	return current_amount * percent
