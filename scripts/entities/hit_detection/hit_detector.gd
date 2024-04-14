# A wrapper for Area2D that ties the area to the root node of an "entity"

class_name HitDetector
extends Area2D


signal wall_entered(body: Node2D)
signal wall_exited(body: Node2D)
signal detector_entered(other_hit_detector: HitDetector)
signal detector_exited(other_hit_detector: HitDetector)

enum TeamMode {
	ANY,
	ALLY,
	ENEMY
}

enum DetectorType {
	HURTBOX,
	HITBOX
}

@export var enabled: bool = true :
	get:
		return _enabled
	set(value):
		_enabled = value
		monitoring = value
		monitorable = value
var _enabled: bool = true
@export var entity: Node
@export var mode: TeamMode
@export var type: DetectorType
@export var team: Team
@export var track_wall: bool

# [HitDetector]: null
var detectors: Dictionary


func _ready():
	area_entered.connect(_on_enter)
	area_exited.connect(_on_exit)
	enabled = enabled
	if track_wall:
		body_entered.connect(_on_body_entered)
		body_exited.connect(_on_body_exited)


func set_enabled(_enabled: bool):
	enabled = true


func _on_body_entered(body: Node2D):
	if body.is_in_group("Wall"):
		wall_entered.emit(body)


func _on_body_exited(body: Node2D):
	if body.is_in_group("Wall"):
		wall_exited.emit(body)


func _on_enter(area: Area2D):
	if area is HitDetector:
		if area.type != type and _can_add(area.entity):
			detectors[area] = null
			detector_entered.emit(area)


func _on_exit(area: Area2D):
	if area in detectors:
		detectors.erase(area)
		detector_exited.emit(area)


func _can_add(other_entity: Node2D) -> bool:
	if mode == TeamMode.ANY:
		return true
	var other_team = other_entity.get_node_or_null("Team") as Team
	if other_team:
		match mode:
			TeamMode.ALLY:
				return other_team.team == team.team
			TeamMode.ENEMY:
				return other_team.team != team.team
	return false
