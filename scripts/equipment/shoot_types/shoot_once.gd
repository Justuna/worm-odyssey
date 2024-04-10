extends Node
class_name ShootOnce


signal on_shoot

@export var bullet_prefab: PackedScene
@export var muzzle: Node2D
@export var team: Team


func shoot():
	var bullet = bullet_prefab.instantiate() as Projectile
	World.instance.add_child(bullet)
	bullet.construct(muzzle.global_position, Node2DUtils.local_to_global_dir(muzzle, Vector2.UP), team.team)
	on_shoot.emit()

