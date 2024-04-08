# A wrapper for Area2D that ties the area to the root node of an "entity"

class_name HitDetector
extends Area2D


signal wall_entered(body: Node2D)
signal wall_exited(body: Node2D)
signal detector_entered(other_hit_detector: HitDetector)
signal detector_exited(other_hit_detector: HitDetector)

enum Mode {
	ANY,
	ALLY,
	ENEMY
}

@export var entity: Node
@export var mode: Mode
@export var team: Team
@export var track_wall: bool

# [HitDetector]: null
var detectors: Dictionary


func _ready():
	area_entered.connect(_on_enter)
	area_exited.connect(_on_exit)
	if track_wall:
		body_entered.connect(_on_body_entered)
		body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D):
	if body.is_in_group("Wall"):
		wall_entered.emit(body)


func _on_body_exited(body: Node2D):
	if body.is_in_group("Wall"):
		wall_exited.emit(body)


func _on_enter(area: Area2D):
	if area is HitDetector:
		if _can_add(area.entity):
			detectors[area] = null
			detector_entered.emit(area)


func _on_exit(area: Area2D):
	if area in detectors:
		detectors.erase(area)
		detector_exited.emit(area)


func _can_add(other_entity: Node2D) -> bool:
	if mode == Mode.ANY:
		return true
	var other_team = other_entity.get_node_or_null("Team") as Team
	if other_team:
		match mode:
			Mode.ALLY:
				return other_team.team == team.team
			Mode.ENEMY:
				return other_team.team != team.team
	return false
