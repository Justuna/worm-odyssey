## Represents an entity with the capability to deal a hit to other entities once 
## at most over its lifetime. Also has a special signal for when a certain
## number of entities have been hit by the projectile.
## Intended for piercing attacks.
##
## Can land crits.
class_name HitLimit
extends HitOnce


signal reached_hit_limit

@export var hit_limit: int = 1

var _hit_count: int = 0
var _hit_limit_reached = false


func _deal_hit(hit_taker: HitTaker):
	_hit_count += 1
	if hit_limit > 0 and not _hit_limit_reached and _hit_count > hit_limit:
		_hit_limit_reached = true
		reached_hit_limit.emit()
	super._deal_hit(hit_taker)
