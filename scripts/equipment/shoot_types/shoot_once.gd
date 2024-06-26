extends Node
class_name ShootOnce


signal on_shoot

@export var bullet_prefab: PackedScene
@export var muzzle: Node2D
@export var team: Team
@export var delay: float


func shoot():
	await get_tree().create_timer(delay).timeout
	var bullet = bullet_prefab.instantiate() as Projectile
	World.instance.add_child(bullet)
	bullet.construct(muzzle.global_position, Node2DUtils.local_to_global_dir(muzzle, Vector2.UP), team)
	on_shoot.emit()

