class_name Death
extends Node

@export var use_lifetime: bool
@export var lifetime: float
@export var entity: Node
@export var death_prefabs: Array[PackedScene]


var _is_dead: bool
var _lifetime_timer: float


func _process(delta):
	if use_lifetime:
		_lifetime_timer += delta
		if _lifetime_timer >= lifetime:
			die()
 

func die():
	if _is_dead:
		return
	_is_dead = true
	for prefab in death_prefabs:
		var node = prefab.instantiate()
		entity.get_parent().add_child(node)
	entity.queue_free()
