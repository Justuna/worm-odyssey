## Chases the nearest enemy in a straight line, and wanders otherwise
## Requirements:
## - Entity must have a Team node
## - Parent must be a CharacterBody2D
class_name ChaseAI
extends Node2D


enum State {
	CHASE,
	WANDER_WALK,
	WANDER_WAIT
}

@export var enemy_detector: EntityTracker
@export var speed: float = 50
@export var wander_walk_interval: Vector2 = Vector2(2, 4)
@export var wander_wait_interval: Vector2 = Vector2(0.5, 2)

@onready var body: CharacterBody2D = get_parent() as CharacterBody2D

var state: State = State.WANDER_WALK

var _wander_walk_timer: float
var _wander_direction: Vector2

var _wait_timer: float


func _ready():
	if Engine.is_editor_hint():
		set_process(false)
		return
	enemy_detector.team = get_parent().get_node("Team")


func _process(delta):
	if enemy_detector.nearest_entity:
		if not state == State.CHASE:
			_switch_state(State.CHASE)
	
	match state:
		State.CHASE:
			body.velocity = speed * (enemy_detector.nearest_entity.global_position - global_position).normalized()
		State.WANDER_WALK:
			_wander_walk_timer -= delta
			if _wander_walk_timer <= 0:
				_switch_state(State.WANDER_WAIT)
		State.WANDER_WAIT:
			_wait_timer -= delta
			if _wait_timer <= 0:
				_switch_state(State.WANDER_WALK)	


func _switch_state(_state: State):
	state = _state
	match state:
		State.WANDER_WALK:
			_wander_walk_timer = randf_range(wander_walk_interval.x, wander_walk_interval.y)
			_wander_direction = Vector2.from_angle(randf_range(0, 2*PI))
		State.WANDER_WAIT:
			_wait_timer = randf_range(wander_wait_interval.x, wander_walk_interval.y)
		