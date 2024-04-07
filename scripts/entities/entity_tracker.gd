class_name EntityTracker
extends Area2D


signal on_entity_detected(entity: Node2D)
signal on_entity_undetected(entity: Node2D)

enum Mode {
	ANY,
	ALLY,
	ENEMY
}

@export var mode: Mode
@export var team: Team
@export var track_nearest_entity: bool

# [Node2D]: null
var entities: Dictionary
var nearest_entity: Node2D :
	get:
		if not is_instance_valid(_nearest_entity):
			_nearest_entity = null
		return _nearest_entity
var _nearest_entity: Node2D


func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _process(delta):
	if track_nearest_entity:
		if entities.size() > 0:
			var entities = entities.keys()
			_nearest_entity = entities[0] as Node2D
			var nearest_entity_dist = global_position.distance_squared_to(nearest_entity.global_position)
			for entity: Node2D in entities:
				if not is_instance_valid(entity):
					entities.erase(entity)
					continue
				var curr_dist = global_position.distance_squared_to(entity.global_position)
				if curr_dist < nearest_entity_dist:
					_nearest_entity = entity
					nearest_entity_dist = curr_dist
		elif nearest_entity:
			_nearest_entity = null


func _can_add(other_team: Team) -> bool:
	match mode:
		Mode.ALLY:
			return other_team.team == team.team
		Mode.ENEMY:
			return other_team.team != team.team
	return true


func _on_area_entered(area: Area2D):
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
