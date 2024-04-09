extends Node2D
class_name WormSegment


enum Binding {
	NONE,
	X_BUTTON,
	Y_BUTTON,
	B_BUTTON,
	A_BUTTON
}


signal on_death

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
@export var equipment_container: Node2D
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
@export var health: Health
@export var team: Team
@export var stat_block: StatBlock
@export var health_indicator: Sprite2D
@export var health_indicator_container: Node2D
@export var damage_gradient: Gradient

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
	_update_is_selected_visuals()
	_update_is_moving_visuals()
	canvas_group.material = canvas_group.material.duplicate()
	health_indicator.material = health_indicator.material.duplicate()
	health.on_death.connect(_on_death)
	health.on_health_changed.connect(_on_health_changed.unbind(1))
	health_indicator_container.visible = false


func construct(_worm: Node2D, _team: String):
	worm = _worm
	team.team = _team


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
			equipment.reparent(equipment_container)
		else:
			equipment_container.add_child(equipment)
		stat_block.sync_modifiers_stat_block = equipment.stat_block
		equipment.position = Vector2.ZERO
		equipment.rotation = 0
		equipment.construct(worm, self, direction)
		_update_binding_visuals()
	return old_equipment


func remove_equipment() -> Equipment:
	if equipment:
		equipment_container.remove_child(equipment)
		var old_equipment = equipment
		stat_block.sync_modifiers_stat_block = null
		equipment.destruct()
		equipment = null
		_update_binding_visuals()
		return old_equipment
	else:
		return null


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
		var scale_tween = get_tree().create_tween()
		scale_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		if _is_selected:
			scale_tween.tween_property(canvas_group, "scale", Vector2(1.5, 1.5), 0.25)
		else:
			scale_tween.tween_property(canvas_group, "scale", Vector2(1, 1), 0.25)


func _update_is_moving_visuals():
	if canvas_group:
		if _is_moving:
			(canvas_group.material as ShaderMaterial).set_shader_parameter("overlay_2_enabled", true)
		else:
			(canvas_group.material as ShaderMaterial).set_shader_parameter("overlay_2_enabled", false)


func _on_death():
	on_death.emit()


func _on_health_changed():
	var fill_amount = float(health.health) / health.max_health.amount
	if fill_amount == 1.0:
		health_indicator_container.visible = false
	else:
		health_indicator_container.visible = true
		var prev_fill_amount = (health_indicator.material as ShaderMaterial).get_shader_parameter("fill_amount")
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_method(_animate_health_indicator, prev_fill_amount, fill_amount, 0.5)


func _animate_health_indicator(fill_amount: float):
	var fill_color = damage_gradient.sample(fill_amount)
	health_indicator.self_modulate = fill_color
	fill_color.s += 0.1
	fill_color.v -= 0.2
	(health_indicator.material as ShaderMaterial).set_shader_parameter("background_color", fill_color)
	(health_indicator.material as ShaderMaterial).set_shader_parameter("fill_amount", fill_amount)
