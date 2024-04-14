class_name Flicker
extends Node


@export var visuals: CanvasGroup
@export var frequency: float
@export var curve: Curve

var activated: bool:
	get: return _activated

var _activated = false
var _timer: float


func start():
	_activated = true
	_timer = frequency


func _process(delta):
	if not _activated:
		return

	_timer -= delta
	if _timer <= 0:
		_timer = frequency
	visuals.self_modulate.a = curve.sample(_timer / frequency)
