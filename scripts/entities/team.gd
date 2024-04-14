class_name Team
extends Node


@export var entity_owner: Node2D
@export var team: String


func construct(_team: String, _entity_owner: Node2D = null):
	team = _team
	if _entity_owner:
		entity_owner = _entity_owner


## Copies the values for a given team
##
## Useful for when projectiles spawn other
## projectiles, but the entity_owner of the new
## projectile should point back to the shooter
## instead of the old projectile
func construct_copy(_team: Team):
	entity_owner = _team.entity_owner
	team = _team.team
