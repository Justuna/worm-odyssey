class_name World
extends Node2D


@export var shop_inflation: Economy

static var instance: World :
	get:
		return _instance
static var _instance: World

const MAX_ENEMIES: int = 40
var enemy_counter: int = 0


var _to_be_added: Array[Array]


func _enter_tree():
	if instance:
		queue_free()
		return
	_instance = self


func _process(_delta):
	while _to_be_added.size() > 0:
		var add = _to_be_added.pop_front()

		var node = add[0] as Node2D
		var pos = add[1] as Vector2
		if node != null and pos != null:
			add_child(node)
			node.position = pos
		

func defer_spawn(node: Node2D, pos: Vector2):
	_to_be_added.push_back([node, pos])