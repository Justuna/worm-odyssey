# Represents an entity or area that continuously deals hits to other entities that overlap with it. Meant for areas of effect.

class_name HitContinuously
extends HitType

@export var tick_rate: float

var _can_hit: Dictionary
var _timers: Dictionary

func _init():
	hitbox.detector_entered.connect(_register_can_hit)
	hitbox.detector_exited.connect(_deregister_can_hit)

func _process(delta):
	for entity in _timers:
		_timers[entity] = max(_timers[entity] - delta, 0)
		if _timers[entity] == 0:
			_deal_hit(entity)
			_timers[entity] = tick_rate


func _register_can_hit(_hit_detector: HitDetector, other_hit_detector: HitDetector):
	if other_hit_detector.entity in _can_hit:
		_can_hit[other_hit_detector.entity] += 1
	else:
		_can_hit[other_hit_detector.entity] = 1
		_timers[other_hit_detector.entity] = tick_rate;
		_deal_hit(other_hit_detector.entity)


func _deregister_can_hit(_hit_detector: HitDetector, other_hit_detector: HitDetector):
	if other_hit_detector in _can_hit:
		_can_hit[other_hit_detector.entity] -= 1
		if _can_hit[other_hit_detector.entity] == 0:
			_can_hit.erase(other_hit_detector.entity)
			_timers.erase(other_hit_detector.entity)

func _deal_hit(hit_entity: Node):
	var health = hit_entity.get_node("Health")
	if health != null and health is Health:
		if is_healing:
			health.take_healing(damage)
		else:
			health.take_damage(damage)
	
	var effect_holder = hit_entity.get_node("EffectHolder")
	if effect_holder != null and effect_holder is EffectHolder:
		for effect in effects:
			effect_holder.add_effect(effect)
	
	hit_dealt.emit(hit_entity)
