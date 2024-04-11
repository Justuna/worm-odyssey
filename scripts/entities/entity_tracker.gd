class_name EntityTracker
extends Area2D


signal on_entity_detected(entity: Node2D)
signal on_entity_undetected(entity: Node2D)

signal target_entity_changed

enum Mode {
	ANY,
	ALLY,
	ENEMY
}

enum TargetMode {
	ANY,
	CLOSEST,
	FARTHEST
}

@export var enabled: bool = true :
	get:
		return _enabled
	set(value):
		_enabled = value
		if _is_readied:
			monitoring = _enabled
			monitorable = _enabled
			set_process(_enabled)
			if not _enabled:
				# If we are disabling ourselves, then clean everything up
				_target_entity = null
				entities.clear()
var _enabled: bool = true
@export var mode: Mode
@export var target_mode: TargetMode = TargetMode.CLOSEST
@export var team: Team

# [Node2D]: null
var entities: Dictionary
var target_entity: Node2D :
	get:
		if not is_instance_valid(_target_entity):
			_target_entity = null
		return _target_entity
var _target_entity: Node2D
var _prev_target_entity: Node2D

@onready var _is_readied: bool = true


func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	enabled = enabled


func _process(delta):
	if entities.size() > 0:
		if target_mode == TargetMode.ANY:
			if not target_entity:
				_target_entity = entities.keys()[0]
		else:
			var entities = entities.keys()
			_target_entity = entities[0] as Node2D
			var target_entity_dist = global_position.distance_squared_to(target_entity.global_position)
			for entity: Node2D in entities:
				if not is_instance_valid(entity):
					entities.erase(entity)
					continue
				var curr_dist = global_position.distance_squared_to(entity.global_position)
				if (target_mode == TargetMode.CLOSEST and curr_dist < target_entity_dist) or (target_mode == TargetMode.FARTHEST and curr_dist > target_entity_dist):
					_target_entity = entity
					target_entity_dist = curr_dist
	else:
		if target_entity:
			_target_entity = null
	
	if _target_entity != _prev_target_entity:
		_prev_target_entity = _target_entity
		target_entity_changed.emit()


func _can_add(other_team: Team) -> bool:
	match mode:
		Mode.ALLY:
			return other_team.team == team.team
		Mode.ENEMY:
			return other_team.team != team.team
	return true


func _on_area_entered(area: Area2D):
	print("Tracker area entered")
	if area is HitDetector and area.get_node_or_null("HitTaker") is HitTaker:
		var body = area.entity
		var other_team = body.get_node_or_null("Team") as Team
		if other_team and _can_add(other_team):
			entities[body] = null
			on_entity_detected.emit(body)


func _on_area_exited(area: Area2D):
	if area is HitDetector and area.get_node_or_null("HitTaker") is HitTaker:
		var body = area.entity
		if body in entities:
			entities.erase(body)
			on_entity_undetected.emit(body)
			if body == target_entity:
				target_entity = null
