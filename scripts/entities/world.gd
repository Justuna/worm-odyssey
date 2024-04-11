class_name World
extends Node2D


static var instance: World :
	get:
		return _instance
static var _instance: World


func _enter_tree():
	if instance:
		queue_free()
		return
	_instance = self
