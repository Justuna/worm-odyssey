class_name Flicker
extends Node


@export var visuals: CanvasGroup
@export var frequency: float

var activated: bool:
    get: return _activated

var _activated = false
var _timer: float


func start():
    _activated = true
    visuals.visible = false
    _timer = frequency


func _process(delta):
    if not _activated:
        return

    _timer -= delta
    if _timer <= 0:
        _timer = frequency
        visuals.visible = !visuals.visible