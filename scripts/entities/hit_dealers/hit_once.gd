# Represents an entity with the capability to deal a hit to other entities once at most over its lifetime. Meant for projectiles and explosions.

class_name HitOnce
extends HitType

@export var can_crit: bool

var _been_hit: Dictionary

func _ready():
	hitbox.detector_entered.connect(_deal_hit)

func _deal_hit(_hit_detector: HitDetector, other_hit_detector: HitDetector):
	var hit_entity = other_hit_detector.entity
	
	if hit_entity in _been_hit:
		return
	else:
		_been_hit[hit_entity] = null
	
	var hit_takers = []
	ClassUtils.get_children_by_class(hit_entity, "HitTaker", hit_takers)

	for hit_taker in hit_takers:
		if not hit_taker is HitTaker: 
			return

		if (hit_taker.hurtbox == other_hit_detector):
			if is_healing:
				hit_taker.route_healing(amount)
			else:
				hit_taker.route_damage(amount, can_crit)
	
	var effect_holder = hit_entity.get_node("EffectHolder")
	if effect_holder != null and effect_holder is EffectHolder:
		for effect in effects:
			effect_holder.add_effect(effect)
	
	hit_dealt.emit(hit_entity)

