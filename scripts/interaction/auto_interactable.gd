extends Node2D
class_name AutoInteractable


signal on_interact()

@export var collision_shape: CollisionShape2D

var enabled: bool :
	get:
		return _enabled
	set(value):
		_enabled = value
		if collision_shape:
			collision_shape.disabled = not enabled

var _enabled: bool = true
var _selected: bool


func _ready():
	enabled = enabled


func interact(auto_interactor: AutoInteractor):
	on_interact.emit(auto_interactor)
