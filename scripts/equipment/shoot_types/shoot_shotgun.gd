extends Node
class_name ShootShotgun


signal on_shoot

@export var random_offset : float
@export var fire_round : int = 1
@export var fire_interval : float
@export var bullet_number : int
@export var angle : float
@export var bullet_prefab: PackedScene
@export var muzzle: Node2D
@export var team: Team



func shoot():
	var even_angle = angle / bullet_number
	for j in range(fire_round) :
		await get_tree().create_timer(fire_interval).timeout
		for i in range(bullet_number) :
			var bullet = bullet_prefab.instantiate() as Projectile
			World.instance.add_child(bullet)
			bullet.construct(muzzle.global_position, Node2DUtils.local_to_global_dir(muzzle, Vector2.from_angle(deg_to_rad(i*even_angle-angle/2-90 + randf_range(-random_offset,random_offset)))), team.team)
		
	on_shoot.emit()

