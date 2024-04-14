@tool
class_name EffectOnDamage
extends Node2D


const RANGE_STAT_MULT = 8


@export var range_stat: Stat
@export var range_stat_multiplier: float
@onready var equipment: Equipment = get_parent() as Equipment
@export var effects: Array[Effect.Type]

var range: float :
	get:
		return range_stat.amount * RANGE_STAT_MULT * range_stat_multiplier
var range_sqr: float :
	get:
		var _range = range
		return _range * _range


func _ready():
	if Engine.is_editor_hint():
		return
	set_process(false)
	equipment.equipped_changed.connect(_on_equipment_changed)


func _process(delta):
	if Engine.is_editor_hint():
		queue_redraw()


func _draw():
	if Engine.is_editor_hint() and range_stat:
		var radius = range_stat.base_amount * RANGE_STAT_MULT * range_stat_multiplier
		draw_circle(Vector2.ZERO, radius, Color(Color.RED, 0.1))
		draw_arc(Vector2.ZERO, radius, 0, TAU, 360, Color.RED)


func _on_equipment_changed():
	if equipment.is_equipped:
		var damage_inst_listener = equipment.segment.worm.get_parent().get_node_or_null("DamageInstanceListener") as DamageInstanceListener
		if damage_inst_listener:
			damage_inst_listener.on_damage_pre.connect(_on_damage_pre)
	else:
		var damage_inst_listener = equipment.segment.worm.get_parent().get_node_or_null("DamageInstanceListener") as DamageInstanceListener
		if damage_inst_listener:
			damage_inst_listener.on_damage_pre.disconnect(_on_damage_pre)


func _on_damage_pre(instance: DamageInstance, health: Health):
	var parent_node2D = health.get_parent() as Node2D
	if parent_node2D and parent_node2D.global_position.distance_squared_to(global_position) < range_sqr:
		var effect_holder = parent_node2D.get_node_or_null("EffectHolder") as EffectHolder
		if effect_holder:
			for effect in effects:
				effect_holder.add_effect(effect)
