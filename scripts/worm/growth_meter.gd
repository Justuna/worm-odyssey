class_name GrowthMeter
extends Node


@export var worm_controller: WormController
@export var growth_meter: Economy
@export var growth_requirement: float


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	while growth_meter.value > growth_requirement:
		growth_meter.value -= growth_requirement
		worm_controller.grow()
		
func grow(amount: float):
	growth_meter.value += amount
		
