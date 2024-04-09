extends Node2D
class_name AutoInteractable


signal on_available()
signal on_interact()


var available: bool :
	get:
		return _available
	set(value):
		_available = value
		if _available:
			on_available.emit()

var _available: bool = true
var _selected: bool


func interact(auto_interactor: AutoInteractor):
	on_interact.emit(auto_interactor)
