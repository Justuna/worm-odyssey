class_name EquipmentTurret
extends Node2D


signal on_shoot


@export var turret_head: Node2D
@export var turret_muzzle: Node2D
@export var entity_tracker: EntityTracker
@export var fire_interval: float = 1
@export var lock_in_duration: float = 0.5
@export var angle_offset: float = 90
@export var team: Team

@onready var equipment = get_parent() as Equipment

var _is_tweening: bool = false
var _tween: Tween
var _fire_timer: float = 0


func _ready():
	entity_tracker.target_entity_changed.connect(_target_changed)
	equipment.equipped_changed.connect(_on_equipped_changed)
	set_process(false)


func _on_equipped_changed():
	set_process(equipment.is_equipped)
	entity_tracker.enabled = equipment.is_equipped
	if not equipment.is_equipped and _tween and _tween.is_running():
		_tween.kill()


func _process(delta):
	if entity_tracker.target_entity and not _is_tweening:
		# Lock in to the target entity
		turret_head.global_rotation = (entity_tracker.target_entity.global_position - turret_head.global_position).angle() + deg_to_rad(angle_offset)
		_fire_timer -= delta
		if _fire_timer <= 0:
			_fire_timer = fire_interval
			shoot()


func shoot():
	on_shoot.emit()


func _target_changed():
	if entity_tracker.target_entity != null:
		_tween = get_tree().create_tween()
		_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		_tween.tween_method(_tween_turret.bind(turret_head.global_rotation), 0.0, 1.0, lock_in_duration)
		_tween.finished.connect(_on_tween_finished)
		_is_tweening = true


func _tween_turret(amount: float, turret_head_start_rot: float):
	if not entity_tracker.target_entity:
		_tween.kill()
		_is_tweening = false
	else:
		var angle_to_target = (entity_tracker.target_entity.global_position - turret_head.global_position).angle() + deg_to_rad(angle_offset)
		turret_head.global_rotation = lerp_angle(turret_head_start_rot, angle_to_target, amount)

		
func _on_tween_finished():
	_is_tweening = false
	_fire_timer = 0
