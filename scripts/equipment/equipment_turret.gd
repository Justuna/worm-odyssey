class_name EquipmentTurret
extends Node2D


signal on_shoot


@export var turret_head: Node2D
@export var turret_muzzle: Node2D
@export var entity_tracker: EntityTracker
@export var fire_interval: float = 1
@export var lock_in_duration: float = 0.5
@export var team: Team

@onready var equipment = get_parent() as Equipment

var _is_tweening: bool = false
var _is_locking_to_direction: bool = false
var _tween: Tween
var _fire_timer: float = 0


func _ready():
	entity_tracker.target_entity_changed.connect(_target_changed)
	equipment.equipped_changed.connect(_on_equipped_changed)
	_on_equipped_changed()
	set_process(false)


## Locks to the equipment's assigned direction temporarily
func lock_to_direction(hold_duration: float = 1):
	_is_locking_to_direction = true
	_is_tweening = true
	if _is_tweening:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_method(_tween_turret_to_direction.bind(turret_head.rotation), 0.0, 1.0, lock_in_duration)
	_tween.finished.connect(_on_tween_turret_to_direction_finished.bind(hold_duration))


func _on_equipped_changed():
	set_process(equipment.is_equipped)
	entity_tracker.enabled = equipment.is_equipped
	if not equipment.is_equipped and _tween and _tween.is_running():
		_tween.kill()


func _process(delta):
	if entity_tracker.target_entity and not _is_tweening:
		# Lock in to the target entity
		turret_head.global_rotation = (entity_tracker.target_entity.global_position - turret_head.global_position).angle() + deg_to_rad(90)
		_fire_timer -= delta
		if _fire_timer <= 0:
			_fire_timer = fire_interval
			shoot()


func shoot():
	on_shoot.emit()


func _target_changed():
	if entity_tracker.target_entity != null and not _is_locking_to_direction:
		_tween = get_tree().create_tween()
		_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		_tween.tween_method(_tween_turret_to_target.bind(turret_head.global_rotation), 0.0, 1.0, lock_in_duration)
		_tween.finished.connect(_on_tween_turret_to_target_finished)
		_is_tweening = true


func _tween_turret_to_target(amount: float, turret_head_start_rot: float):
	if not entity_tracker.target_entity:
		_tween.kill()
		_is_tweening = false
	else:
		var angle_to_target = (entity_tracker.target_entity.global_position - turret_head.global_position).angle() + deg_to_rad(90)
		turret_head.global_rotation = lerp_angle(turret_head_start_rot, angle_to_target, amount)


func _on_tween_turret_to_target_finished():
	_is_tweening = false
	_fire_timer = 0


func _tween_turret_to_direction(amount: float, turret_head_start_rot: float):
	# Use local rotation since turret is relative to equipment
	var rotation_angle = Equipment.DIRECTION_TO_RADIANS[equipment.direction]
	turret_head.rotation = lerp_angle(turret_head_start_rot, rotation_angle, amount)


func _on_tween_turret_to_direction_finished(hold_duration: float):
	# Keep the turret in place for a duration
	await get_tree().create_timer(hold_duration).timeout
	_is_tweening = false
	_is_locking_to_direction = false
	
	# Retarget to target position after finishing locking in
	_target_changed()
