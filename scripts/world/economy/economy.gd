# Base class for any system that has a value that scales with time. Can also be deducted from or added to, like a balance.

class_name Economy
extends Node


@export var base_value: float = 0

# Timestep and value can both be modified externally
# For things like deducting costs or resetting the growth rate

var t: float = 0
var value: float


func _enter_tree():
	value = base_value


func _physics_process(delta):
	t += delta
