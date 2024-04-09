class_name Death
extends Node2D


@export var use_lifetime: bool
@export var lifetime: float
@export var entity: Node
@export var death_prefabs: Array[PackedScene]
@export var death_fx: Array[FX]
@export var use_children_fx: bool = true


var _is_dead: bool
var _lifetime_timer: float


func _ready():
	if use_children_fx:
		for child in get_children():
			if child is FX and not death_fx.has(child):
				death_fx.append(child)


func _process(delta):
	if use_lifetime:
		_lifetime_timer += delta
		if _lifetime_timer >= lifetime:
			die()
 

func die():
	if _is_dead:
		return
	_is_dead = true
	for fx in death_fx:
		fx.play()
	for prefab in death_prefabs:
		var node = prefab.instantiate()
		entity.get_parent().add_child(node)
	entity.queue_free()
