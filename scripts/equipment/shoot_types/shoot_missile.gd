extends Node
class_name ShootMissile


signal on_reload
signal on_shoot

@export var missile_prefabs: Array[PackedScene]
@export var muzzle: Node2D
@export var team: Team
@export var reload_duration: float

var loaded_missile: Projectile

var is_spawning_missile: bool :
	get:
		return _spawn_tween and _spawn_tween.is_running()
var is_despawning_missile: bool :
	get:
		return _despawn_tween and _despawn_tween.is_running()

var _despawn_tween: Tween
var _spawn_tween: Tween
var _reload_timer: float


func _ready():
	spawn_missile.call_deferred(false)


func _process(delta):
	if _reload_timer > 0:
		_reload_timer -= delta
		if _reload_timer <= 0:
			spawn_missile()


func despawn_missile(animate):
	if not is_instance_valid(loaded_missile):
		return
	if _despawn_tween and _despawn_tween.is_running():
		_despawn_tween.kill()
		_finish_despawn_missile()
	if animate:
		var curr_loaded_missile = loaded_missile
		_despawn_tween = create_tween()
		_despawn_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		_despawn_tween.tween_property(loaded_missile, "scale", Vector2.ZERO, 0.5)
		await _despawn_tween.finished
	if is_instance_valid(loaded_missile):
		_finish_despawn_missile()


func _finish_despawn_missile():
	_spawn_tween = null
	loaded_missile.queue_free()


func spawn_missile(missile_index: int = 0, animate: bool = true):
	_reload_timer = 0
	if _spawn_tween and _spawn_tween.is_running():
		_spawn_tween.kill()
	if is_instance_valid(loaded_missile):
		await despawn_missile(animate)
	loaded_missile = missile_prefabs[missile_index].instantiate() as Projectile
	muzzle.add_child(loaded_missile)
	loaded_missile.global_position = muzzle.global_position
	if animate:
		loaded_missile.scale = Vector2.ZERO
		_spawn_tween = create_tween()
		_spawn_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		_spawn_tween.tween_property(loaded_missile, "scale", Vector2.ONE, 0.5)
		await _spawn_tween.finished
	on_reload.emit()


func spawn_and_shoot_missile(missile_index: int = 0, animate: bool = true):
	await spawn_missile(missile_index, animate)
	shoot()


func shoot():
	if is_despawning_missile or is_spawning_missile or not is_instance_valid(loaded_missile):
		return
	loaded_missile.reparent(World.instance)
	loaded_missile.construct(muzzle.global_position, Node2DUtils.local_to_global_dir(muzzle, Vector2.UP), team.team)
	loaded_missile = null
	on_shoot.emit()
	_reload_timer = reload_duration
