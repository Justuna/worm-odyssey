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
var is_selected: bool :
	get:
		return _is_selected
	set(value):
		var old_val = _is_selected
		_is_selected = value
		if _is_selected != old_val:
			_update_is_selected_visuals()
var _is_selected: bool
var is_moving: bool :
	get:
		return _is_moving
	set(value):
		var old_val = _is_moving
		_is_moving = value
		if _is_moving != old_val:
			_update_is_moving_visuals()
var _is_moving: bool

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

var _tween: Tween


func _ready():
	_update_binding_visuals()
	_update_is_selected_visuals()
	_update_is_moving_visuals()
	canvas_group.material = canvas_group.material.duplicate()


func construct(_worm: Node2D):
	worm = _worm


## Swaps this segment's equipment with another segment's equipment.
func swap_equipment(other_segment: WormSegment):
	# Swap equipment, preserving direction
	var my_equipment = remove_equipment()
	var direction = Equipment.Direction.UP
	if my_equipment:
		direction = my_equipment.direction
	var other_equipment = other_segment.add_equipment(my_equipment, direction)
	direction = Equipment.Direction.UP
	if other_equipment:
		direction = other_equipment.direction
	add_equipment(other_equipment, direction)
	
	# Swap bindings
	var my_binding = binding
	binding = other_segment.binding
	other_segment.binding = my_binding 
	


## Tries to add _equipment to this segment. If this segment already has
## an equipment, then the old equipment is returned
func add_equipment(_equipment: Equipment, direction: Equipment.Direction) -> Equipment:
	var old_equipment = null
	if equipment != null:
		old_equipment = remove_equipment()
	equipment = _equipment
	if equipment:
		if equipment.get_parent():
			equipment.reparent(canvas_group)
		else:
			canvas_group.add_child(equipment)
		equipment.position = Vector2.ZERO
		equipment.rotation = 0
		equipment.construct(worm, self, direction)
		_update_binding_visuals()
	return old_equipment


func remove_equipment() -> Equipment:
	if equipment:
		canvas_group.remove_child(equipment)
	var old_equipment = equipment
	equipment = null
	_update_binding_visuals()
	return old_equipment


func use_active():
	equipment.use_active()


func _update_binding_visuals():
	if canvas_group:
		if _binding == Binding.NONE:
			(canvas_group.material as ShaderMaterial).set_shader_parameter("line_enabled", false)
		else:
			(canvas_group.material as ShaderMaterial).set_shader_parameter("line_enabled", true)
			var binding_color = BINDING_TO_COLOR[_binding]
			(canvas_group.material as ShaderMaterial).set_shader_parameter("line_color", binding_color)


func _update_is_selected_visuals():
	if canvas_group:
		if _tween and _tween.is_running():
			_tween.kill()
		_tween = get_tree().create_tween()
		_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		if _is_selected:
			_tween.tween_property(canvas_group, "scale", Vector2(1.5, 1.5), 0.25)
		else:
			_tween.tween_property(canvas_group, "scale", Vector2(1, 1), 0.25)


func _update_is_moving_visuals():
	if canvas_group:
		if _is_moving:
			(canvas_group.material as ShaderMaterial).set_shader_parameter("overlay_enabled", true)
		else:
			(canvas_group.material as ShaderMaterial).set_shader_parameter("overlay_enabled", false)
