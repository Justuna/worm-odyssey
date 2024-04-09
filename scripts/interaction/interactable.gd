extends Node2D
class_name Interactable


signal on_available()
signal on_interact()
signal on_unavailable()


## Interactable is selected when it's in the range of an Interactor
## and is chosen as the Interactable that the Interactor will
## interact with next.
##
## Selected Interactables have a special visual outline.
@export var selected: bool :
	get:
		return _selected
	set(value):
		_selected = value
		_update_selected_visuals()
@export var visuals: CanvasGroup
@export var selected_color: Color

var available: bool :
	get:
		return _available
	set(value):
		_available = value
		if _available:
			on_available.emit()
		else:
			on_unavailable.emit()

var _available: bool = true
var _selected: bool


func _ready():
	_update_selected_visuals()
	visuals.material = visuals.material.duplicate()


func interact(interactor: Interactor):
	on_interact.emit(interactor)


func _update_selected_visuals():
	if _selected:
		(visuals.material as ShaderMaterial).set_shader_parameter("line_enabled", true)
		(visuals.material as ShaderMaterial).set_shader_parameter("line_color", selected_color)
	else:
		(visuals.material as ShaderMaterial).set_shader_parameter("line_enabled", false)
