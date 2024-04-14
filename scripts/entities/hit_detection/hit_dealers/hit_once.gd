## Represents an entity with the capability to deal a hit to other entities once 
## at most over its lifetime. Meant for projectiles and explosions.
## Can land crits.
class_name HitOnce
extends HitType


var _been_hit: Dictionary


func _ready():
	hitbox.detector_entered.connect(_on_detector_entered)


func _on_detector_entered(other_hit_detector: HitDetector):	
	var hit_taker = other_hit_detector.get_node_or_null("HitTaker")
	if not hit_taker:
		return
	
	var hit_entity = other_hit_detector.entity
	if hit_entity in _been_hit:
		return
	else:
		_been_hit[hit_entity] = null
	
	_deal_hit(hit_taker)


func _deal_hit(hit_taker: HitTaker):
	if damage_inst:
		reset_damage_inst()
		hit_taker.route_damage_inst(damage_inst, can_crit)

	var hit_entity = hit_taker.hurtbox.entity
	var effect_holder = hit_entity.get_node("EffectHolder")
	if effect_holder != null and effect_holder is EffectHolder:
		for effect in effects:
			effect_holder.add_effect(effect)
	
	hit_dealt.emit(hit_entity)
