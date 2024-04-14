class_name Pickup
extends Node


signal picked_up

@export_group("Dependencies")
@export var interactable: Interactable
@export var visuals_container: Node2D
@export var disguise: Node2D
@export var root: Node

# pickup_condition(interactor: Interactor): bool
var pickup_condition: Callable = _always_true


func _always_true(interactor: Interactor) -> bool:
	return true
