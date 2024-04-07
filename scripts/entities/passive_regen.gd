# Represents an entity's capability to passively heal itself over time. Can be set to be interrupted by damage if the interrupt time is greater than 0.
class_name PassiveRegen
extends Node


@export var health: Health

@export var tick_heal: int
@export var tick_rate: float
@export var interrupt_time: float

var _timer = 0
var _interrupt_timer = 0


func _ready():
	health.on_damage.connect(_interrupt)
	_timer = tick_rate


func _process(delta):
	var tick_time = max(delta - _interrupt_timer, 0)

	if _interrupt_timer > 0:
		_interrupt_timer = max(_interrupt_timer - delta, 0)
	
	_timer = max(_timer - tick_time, 0)
	if _timer == 0:
		health.take_healing(tick_heal)
		_timer = tick_rate


func _interrupt():
	_interrupt_timer = max(interrupt_time, _timer)
	_timer = 0
