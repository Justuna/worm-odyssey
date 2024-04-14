## Represents an entity or area that continuously deals hits to other entities that 
## overlap with it. Meant for areas of effect.
## Cannot land crits.
class_name HitContinuously
extends HitType


@export var tick_rate: float
## Delay between hits.
## Limits the amount of attacks this hitbox 
## can make during a short amount of time.
@export var hit_cooldown: float
## Maximum number of hits before
## this hitbox goes on cooldown.
@export var max_hits: int

# [Node (Entity)]: null
var _can_hit: Dictionary
# [Node (Entity)]: float (Timer)
var _timers: Dictionary
var _cooldown_timer: float
var _is_on_cooldown: bool
var _curr_hits: int

var _has_cooldown: bool :
	get:
		return hit_cooldown > 0


func _ready():
	hitbox.detector_entered.connect(_on_detector_entered)
	hitbox.detector_exited.connect(_on_detector_exited)
	_cooldown_timer = 0.0
	_curr_hits = 0
	_is_on_cooldown = false


func _process(delta):
	for entity in _timers.keys():
		if not is_instance_valid(entity):
			_timers.erase(entity)
			_can_hit.erase(entity)
			continue
		_timers[entity] = max(_timers[entity] - delta, 0)
		if _timers[entity] == 0:
			_timers[entity] = tick_rate
			_deal_hit(entity)
	if _is_on_cooldown and _cooldown_timer > 0:
		_cooldown_timer -= delta
		if _cooldown_timer <= 0:
			_is_on_cooldown = false
			_curr_hits = 0


func _on_detector_entered(other_hit_detector: HitDetector):
	if not other_hit_detector.entity in _can_hit:
		_can_hit[other_hit_detector.entity] = null
		_timers[other_hit_detector.entity] = tick_rate;
		_deal_hit(other_hit_detector.entity)


func _on_detector_exited(other_hit_detector: HitDetector):
	if other_hit_detector.entity in _can_hit:
		_can_hit.erase(other_hit_detector.entity)
		_timers.erase(other_hit_detector.entity)


func _deal_hit(hit_entity: Node2D):
	if _has_cooldown:
		if _curr_hits >= max_hits:
			if not _is_on_cooldown:
				_is_on_cooldown = true
				_cooldown_timer = hit_cooldown
			return
		else:
			_curr_hits += 1
	
	var health = hit_entity.get_node("Health") as Health
	if damage_inst:
		reset_damage_inst()
		health.take_damage_inst(damage_inst)

	var effect_holder = hit_entity.get_node("EffectHolder")
	if effect_holder != null and effect_holder is EffectHolder:
		for effect in effects:
			effect_holder.add_effect(effect)
	
	hit_dealt.emit(hit_entity)
