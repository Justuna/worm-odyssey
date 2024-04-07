# A wrapper for Area2D that ties the area to the root node of an "entity"

class_name HitDetector
extends Area2D

@export var entity: Node

signal detector_entered(other_hit_detector: HitDetector)
signal detector_exited(other_hit_detector: HitDetector)

func _ready():
	area_entered.connect(_on_enter)
	area_exited.connect(_on_exit)

func _on_enter(area: Area2D):
	if area is HitDetector:
		detector_entered.emit(area)

func _on_exit(area: Area2D):
	if area is HitDetector:
		detector_exited.emit(area)
