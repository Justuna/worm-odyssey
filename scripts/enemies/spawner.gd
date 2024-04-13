# Based on the "Director" system from Risk of Rain 2
# Will repeatedly try to spawn enemies (more often during "waves")
# Enemies cost credits, and the most expensive enemy is picked
class_name Spawner
extends Node


@export_category("Credits")
@export var base_credits: float = 0
@export var credit_earn_rate: float = 1
@export var too_cheap_factor: float = 6

@export_category("Waves")
@export var start_with_wave: bool
@export var start_buffer_time: float
@export var time_between_waves: float
@export var wave_duration: float
@export var base_spawn_rate: float
@export var wave_spawn_rate: float
@export var number_of_waves: int = 0	# If 0, will spawn endless waves

@export_category("Dependencies")
@export var enemy_library: EnemyLibrary

var _credits: float
var _start_buffer_timer: float
var _between_wave_timer: float
var _wave_timer: float
var _spawn_timer: float
var _wave_count: float


func _ready():
	_credits = base_credits
	_start_buffer_timer = start_buffer_time
	_wave_count = number_of_waves


func _process(delta):
	_credits += credit_earn_rate * delta

	if _start_buffer_timer > 0:
		_start_buffer(delta)
	elif _wave_timer > 0:
		_in_wave(delta)
	else:
		_out_of_wave(delta)
	

func _start_buffer(delta):
	_start_buffer_timer -= delta
	if _start_buffer_timer <= 0:
		if start_with_wave:
			_wave_timer = wave_duration
			_spawn_timer = wave_spawn_rate
		else:
			_between_wave_timer = time_between_waves
			_spawn_timer = base_spawn_rate


func _in_wave(delta):
	_wave_timer -= delta
	if _wave_timer <= 0:
		if _wave_count > 0:
			_wave_count -= 1
			if _wave_count == 0:
				return
		_between_wave_timer = time_between_waves

	if _progress_spawn(delta):
		_spawn_timer = wave_spawn_rate

func _out_of_wave(delta):
	_between_wave_timer -= delta
	if _between_wave_timer <= 0:
		_wave_timer = wave_duration
	
	if _progress_spawn(delta):
		_spawn_timer = base_spawn_rate


func _progress_spawn(delta) -> bool:
	_spawn_timer -= delta;
	if _spawn_timer <= 0:
		_spawn_enemy()
		return true
	
	return false


func _choose_enemy() -> EnemyCard:
	var can_buy = enemy_library.enemy_cards.filter(func(card): return card.credit_cost < _credits)
	if can_buy.length == 0:
		return null
	
	var will_buy = can_buy.filter(func(card): return card.credit_cost > _credits / too_cheap_factor)
	if will_buy.length == 0:
		return can_buy.reduce(func(m, val): return val if val.credit_cost > m else m)
	else:
		return will_buy.pick_random()


func _spawn_enemy():
	var card = _choose_enemy()
	if card:
		_credits -= card.credit_cost
		
		print("Placing %s" % card.name)
		_place_enemy(card.enemy_prefab.instantiate())


func _place_enemy(enemy: Node):
	enemy.queue_free()
