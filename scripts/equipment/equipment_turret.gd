class_name EquipmentTurret
extends Node2D


signal on_shoot


@export var enabled: bool
@export var turret_head: Node2D
@export var turret_muzzle: Node2D
@export var entity_tracker: EntityTracker
@export var bullet_prefab: PackedScene
@export var fire_interval: float = 1
@export var lock_in_duration: float = 0.5
@export var team: Team

var _is_tweening: bool = false
var _tween: Tween
var _fire_timer: float = 0


func _ready():
	entity_tracker.target_entity_changed.connect(_target_changed)


func _process(delta):
	if enabled and entity_tracker.target_entity and not _is_tweening:
		# Lock in to the target entity
		turret_head.look_at(entity_tracker.target_entity.global_position)
		_fire_timer -= delta
		if _fire_timer <= 0:
			_fire_timer = fire_interval
			shoot()


func shoot():
	var bullet = bullet_prefab.instantiate() as Projectile
	bullet.construct(turret_muzzle.global_position, turret_muzzle.to_global(Vector2.UP), team.team)


func _target_changed():
	if enabled and entity_tracker.target_entity != null:
		_tween = get_tree().create_tween()
		_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		_tween.tween_method(_tween_turret.bind(turret_head.global_rotation), 0, 1, lock_in_duration)
		_tween.finished.connect(_on_tween_finished)
		_is_tweening = true


func _tween_turret(amount: float, turret_head_start_rot: float):
	if not entity_tracker.target_entity:
		_tween.kill()
	else:
		turret_head.global_rotation = lerp_angle(turret_head_start_rot, turret_head.get_angle_to(entity_tracker.target_entity.global_position), amount)


func _on_tween_finished():
	_is_tweening = false
	_fire_timer = 0
