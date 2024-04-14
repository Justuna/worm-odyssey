class_name Pickup
extends Node


signal picked_up

@export_group("Dependencies")
@export var interactable: Interactable
@export var visuals_container: Node2D
@export var disguise: Node2D
@export var root: Node

# pickup_condition(): bool
var pickup_condition: Callable = _always_true


func _always_true() -> bool:
	return true
