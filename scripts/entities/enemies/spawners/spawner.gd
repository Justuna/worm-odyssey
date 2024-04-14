# Based on the "Director" system from Risk of Rain 2
# Will repeatedly try to spawn enemies (more often during "waves")
# Enemies cost credits, and the most expensive enemy is picked
class_name Spawner
extends Node


signal before_place_enemy(enemy: Node)
signal after_last_wave(leftover_credits: float)


@export_category("Spawn Rates")
@export var base_spawn_rate: float
@export var wave_spawn_rate: float

@export_category("Waves")
@export var too_cheap_factor: float = 10
@export var start_with_wave: bool
@export var start_buffer_time: float
@export var time_between_waves: float
@export var wave_duration: float
@export var number_of_waves: int = 0	# If 0, will spawn endless waves

@export_category("Dependencies")
@export var wave_cards: Array[WaveCard]
@export var credits: Economy

var _start_buffer_timer: float
var _between_wave_timer: float
var _wave_timer: float
var _spawn_timer: float
var _wave_count: float
var _current_wave_type: WaveCard


func _ready():
	_start_buffer_timer = start_buffer_time
	_wave_count = number_of_waves


func _process(delta):
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
			_start_wave()
		else:
			_between_wave_timer = time_between_waves
			_spawn_timer = base_spawn_rate
		# print("Start buffer over")


func _in_wave(delta):
	_wave_timer -= delta
	if _wave_timer <= 0:
		# print("Wave ended")
		if _wave_count > 0:
			_wave_count -= 1
			if _wave_count == 0:
				after_last_wave.emit(credits.value)
				return
		_between_wave_timer = time_between_waves
		_spawn_timer = base_spawn_rate

	if _progress_spawn(delta):
		_spawn_timer = wave_spawn_rate


func _start_wave():
	_current_wave_type = _choose_full_wave()
	_wave_timer = wave_duration
	_spawn_timer = wave_spawn_rate


func _out_of_wave(delta):
	_between_wave_timer -= delta
	if _between_wave_timer <= 0:
		_start_wave()
		# print("Starting new wave")
	
	if _progress_spawn(delta):
		_spawn_timer = base_spawn_rate


func _progress_spawn(delta) -> bool:
	_spawn_timer -= delta;
	if _spawn_timer <= 0:
		_spawn_enemy()
		return true
	
	return false


func _can_afford_wave(wave: WaveCard) -> bool:
	if wave:
		return wave.enemy_cards.filter(_can_afford_enemy).size() > 0

	return false


func _can_afford_full_wave(wave: WaveCard) -> bool:
	if wave and wave.enemy_cards.size() > 0:
		var cheapest = wave.enemy_cards[0]
		if wave.enemy_cards.size() > 1:
			cheapest = wave.enemy_cards.reduce(func(e, val): return val if val.credit_cost < e.credit_cost else e)

		var full_cost = cheapest.credit_cost * wave_duration / wave_spawn_rate
		return full_cost < credits.value

	return false


func _wave_not_too_cheap(wave: WaveCard) -> bool:
	if wave:
		return wave.enemy_cards.filter(_enemy_not_too_cheap).size() > 0

	return false


func _most_expensive_wave(waves: Array[WaveCard]) -> WaveCard:
	var most_cost = 0
	var most_waves = []

	for wave in waves:
		var cost = _most_expensive_enemy(wave).credit_cost
		if most_waves.size() == 0 or cost > most_cost:
			most_cost = cost
			most_waves = [wave]
		elif cost == most_cost:
			most_waves.push_back(wave)

	if most_waves.size() == 0:
		return null
	
	return most_waves.pick_random()


func _least_expensive_wave(waves: Array[WaveCard]) -> WaveCard:
	var least_cost = 0
	var least_waves = []

	for wave in waves:
		var cost = _most_expensive_enemy(wave).credit_cost
		if least_waves.size() == 0 or cost < least_cost:
			least_cost = cost
			least_waves = [wave]
		elif cost == least_cost:
			least_waves.push_back(wave)

	if least_waves.size() == 0:
		return null
	
	return least_waves.pick_random()


func _can_afford_enemy(enemy: EnemyCard) -> bool:
	if enemy:
		return enemy.credit_cost < credits.value

	return false


func _enemy_not_too_cheap(enemy: EnemyCard) -> bool:
	if enemy:
		return enemy.credit_cost > credits.value / too_cheap_factor

	return false


func _most_expensive_enemy(wave: WaveCard) -> EnemyCard:
	var most_cost = 0
	var most_enemy = []

	# print("Checking wave %s" % wave)
	for enemy in wave.enemy_cards:
		# print(enemy)
		var cost = enemy.credit_cost
		if most_enemy.size() == 0 or cost > most_cost:
			most_cost = cost
			most_enemy = [enemy]
		elif cost == most_cost:
			most_enemy.push_back(enemy)

	if most_enemy.size() == 0:
		return null
	
	return most_enemy.pick_random()


func _choose_single_spawn() -> WaveCard:
	# Filter out wave types where none of the enemies can be afforded

	var can_buy = wave_cards.filter(_can_afford_wave)
	if can_buy.size() == 0:
		return null

	# Filter out wave types where all of the enemies are too cheap
	# If no wave types remain, pick the wave type with the most expensive enemy
	# Otherwise, pick a random wave type from those remaining

	var will_buy = can_buy.filter(_wave_not_too_cheap)
	if will_buy.size() == 0:
		return _most_expensive_wave(can_buy)
	else:
		return will_buy.pick_random()


func _choose_full_wave() -> WaveCard:
	# Tries to pick a wave type it can afford a full wave of
	# If not, goes with the wave with the cheapest enemy and then tries its best

	var can_buy = wave_cards.filter(_can_afford_full_wave)
	if can_buy.size() == 0:
		return _least_expensive_wave(wave_cards)

	var will_buy = can_buy.filter(_wave_not_too_cheap)
	if will_buy.size() == 0:
		return _most_expensive_wave(can_buy)
	else:
		return will_buy.pick_random()


func _choose_wave_type_to_use() -> WaveCard:
	# During a wave, stick to one wave card
	
	if _wave_timer > 0:
		if _can_afford_wave(_current_wave_type):
			return _current_wave_type
		
		return null

	# Outside of a wave, just pick a random wave type from the ones you can afford

	return _choose_single_spawn()


func _choose_enemy() -> EnemyCard:
	if World.instance.enemy_counter > World.MAX_ENEMIES:
		# print("Too many enemies; aborting spawn...")
		return null

	var wave_type =_choose_wave_type_to_use()

	if wave_type == null:
		# print("Could not afford any wave types; aborting spawn...")
		return null

	# Filter out the enemies that cannot be afforded of this wave type

	var can_buy = wave_type.enemy_cards.filter(_can_afford_enemy)
	if can_buy.size() == 0:

		# Should never happen, since you should only get here 
		# if you can afford at least one kind of wave
		return null

	# From the wave type, filter out all of the enemies that are "too cheap"
	# If all of the enemies are too cheap, pick the most expensive one
	# Otherwise, pick a random enemy from those remaining

	var will_buy = can_buy.filter(_enemy_not_too_cheap)
	if will_buy.size() == 0:
		return _most_expensive_enemy(wave_type)
	else:
		return will_buy.pick_random()


func _spawn_enemy():
	var card = _choose_enemy()
	if card:
		credits.value -= card.credit_cost
		
		var enemy = card.enemy_prefab.instantiate()
		enemy.add_child(EnemyTracker.new())
		before_place_enemy.emit(enemy)

		# print("Placing %s" % card.name)
		# print("Have %s credits remaining..." % credits.value)
		_place_enemy(enemy, card)


func _place_enemy(enemy: Node, card: EnemyCard):
	# print("No placement behavior, freeing...")
	enemy.queue_free()
