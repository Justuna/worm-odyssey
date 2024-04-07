# Represents an entity's capability to passively heal itself over time. Can be set to be interrupted by damage if the interrupt time is greater than 0.
class_name PassiveRegen
extends Node


const REGEN_AMOUNT_FACTOR: float = 0.2
const REGEN_RATE_FACTOR: float = 0.01
const REGEN_RATE_MIN: float = 0.25

@export var health: Health

@export var tick_base_heal: int = 1
@export var tick_base_rate: float = 3
@export var interrupt_time: float = 5
@export var regen_stat: Stat


var tick_heal: int :
	get:
		return tick_base_heal + regen_stat.amount * REGEN_AMOUNT_FACTOR
var tick_rate: float :
	get:
		return max(tick_base_rate - regen_stat.amount * REGEN_RATE_FACTOR, REGEN_RATE_MIN)

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


func _interrupt(damage):
	_interrupt_timer = max(interrupt_time, _timer)
	_timer = 0
