extends Node2D
class_name WormSegment


enum Binding {
	NONE,
	X_BUTTON,
	Y_BUTTON,
	B_BUTTON,
	A_BUTTON
}


var worm: Node2D
var equipment: Equipment

@export var canvas_group: CanvasGroup
@export var x_color: Color
@export var y_color: Color
@export var b_color: Color
@export var a_color: Color
@export var binding: Binding :
	get:
		return _binding
	set(value):
		_binding = value
		_update_binding_visuals()

var _binding: Binding
@onready var BINDING_TO_COLOR: Dictionary = {
	Binding.NONE: Color.TRANSPARENT,
	Binding.X_BUTTON: x_color,
	Binding.Y_BUTTON: y_color,
	Binding.B_BUTTON: b_color,
	Binding.A_BUTTON: a_color,
}


func _ready():
	_update_binding_visuals()
	canvas_group.material = canvas_group.material.duplicate()


func construct(_worm: Node2D):
	worm = _worm


## Tries to add _equipment to this segment. If this segment already has
## an equipment, then the old equipment is returned
func add_equipment(_equipment: Equipment, direction: Equipment.Direction) -> Equipment:
	var old_equipment = null
	if equipment != null:
		old_equipment = remove_equipment()
	equipment = _equipment
	equipment.reparent(canvas_group)
	equipment.position = Vector2.ZERO
	equipment.rotation = 0
	equipment.construct(worm, self, direction)
	_update_binding_visuals()
	return old_equipment


func remove_equipment() -> Equipment:
	equipment.reparent(null)
	var old_equipment = equipment
	equipment = null
	_update_binding_visuals()
	return old_equipment


func use_active():
	equipment.use_active()


func _update_binding_visuals():
	if canvas_group:
		if _binding == Binding.NONE:
			(canvas_group.material as ShaderMaterial).set_shader_parameter("enabled", false)
		else:
			(canvas_group.material as ShaderMaterial).set_shader_parameter("enabled", true)
			var binding_color = BINDING_TO_COLOR[_binding]
			(canvas_group.material as ShaderMaterial).set_shader_parameter("line_color", binding_color)
