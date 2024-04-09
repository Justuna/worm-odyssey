@tool
## Lantern Fly AI
## Bug that periodically wanders and flies.
## Releases bullet patterns when flying.
## Requirements:
## - Entity must have a Team node
## - Parent must be a CharacterBody2D
class_name LanternFlyAI
extends Node2D


signal on_shoot

const SPEED_FACTOR: float = 4
const FLY_DURATION: float = 5
const FLY_SHOOT_DURATION: float = 0.5

enum State {
	FLY,
	WANDER_WALK,
	WANDER_WAIT
}

enum Pattern {
	STAR,
	RADIAL,
	SHOTGUN,
	LINE,
}

@export var speed: Stat
@export var wander_walk_interval: Vector2 = Vector2(2, 4)
@export var wander_wait_interval: Vector2 = Vector2(0.5, 2)
@export var bullet_pattern: Pattern :
	get:
		return _bullet_pattern
	set(value):
		_bullet_pattern = value
		_update_bullet_pattern_visuals()
var _bullet_pattern: Pattern

@export_group("Dependencies")
@export var enemy_detector: EntityTracker
@export var animation_player: AnimationPlayer
@export var bullet_prefab: PackedScene
@export var star_pattern_texture: Texture2D
@export var radial_pattern_texture: Texture2D
@export var shotgun_pattern_texture: Texture2D
@export var line_pattern_texture: Texture2D
@export var pattern_sprites: Array[Sprite2D]
@export var team: Team

@onready var body: CharacterBody2D = get_parent() as CharacterBody2D

var state: State = State.WANDER_WALK

var _fly_target_position: Vector2
var _fly_half_way_dist_sqr: float
var _fly_shot_pattern: bool
var _fly_timer: float
# Shoot timer used by Pattern.LINE
var _fly_shoot_timer: float

var _wander_walk_timer: float
var _wander_direction: Vector2

var _wait_timer: float


func _ready():
	_update_bullet_pattern_visuals()
	if Engine.is_editor_hint():
		set_process(false)
		return
	enemy_detector.team = get_parent().get_node("Team")


func _update_bullet_pattern_visuals():
	for sprite: Sprite2D in pattern_sprites:
		match bullet_pattern:
			Pattern.STAR:
				sprite.texture = star_pattern_texture
			Pattern.RADIAL:
				sprite.texture = radial_pattern_texture
			Pattern.SHOTGUN:
				sprite.texture = shotgun_pattern_texture
			Pattern.LINE:
				sprite.texture = line_pattern_texture


func _process(delta):
	match state:
		State.FLY:
			_fly_timer -= delta
			body.velocity = speed.amount * 3 * (_fly_target_position - global_position).normalized()
			body.move_and_slide()
			var dist_sqr_to_target_pos = global_position.distance_squared_to(_fly_target_position)
			if bullet_pattern == Pattern.LINE:
				# Continually spawn bullets in the line
				_fly_shoot_timer -= delta
				if _fly_shoot_timer <= 0:
					_fly_shoot_timer = FLY_SHOOT_DURATION
					_shoot_pattern()
			else:
				# Shoot the pattern halfway through the flight trajectory
				if not _fly_shot_pattern and (_fly_timer <= FLY_DURATION / 2.0 or dist_sqr_to_target_pos < _fly_half_way_dist_sqr):
					_shoot_pattern()
					_fly_shot_pattern = true
			if _fly_timer <= 0 or dist_sqr_to_target_pos < body.velocity.length_squared() * delta * delta:
				_switch_state(State.WANDER_WAIT)
		State.WANDER_WALK:
			_wander_walk_timer -= delta
			body.velocity = speed.amount * _wander_direction
			body.move_and_slide()
			if _wander_walk_timer <= 0:
				_switch_state(State.WANDER_WAIT)
		State.WANDER_WAIT:
			_wait_timer -= delta
			if _wait_timer <= 0:
				_switch_state(State.WANDER_WALK)
				if enemy_detector.target_entity:
					_switch_state(State.FLY)
	
	var real_velocity = body.get_real_velocity()
	if real_velocity.length_squared() > 0:
		body.global_rotation = lerp_angle(body.global_rotation, real_velocity.angle() + deg_to_rad(90), 3 * delta)


func _switch_state(_state: State):
	state = _state
	match state:
		State.FLY:
			# Pick new position to fly to near the player
			_fly_timer = FLY_DURATION
			_fly_shot_pattern = false
			_fly_shoot_timer = 0.0
			var min_range = 2
			var max_range = 4
			if bullet_pattern == Pattern.LINE:
				min_range = 4
				max_range = 8
			_fly_target_position = enemy_detector.target_entity.global_position + RandUtils.rand_circle_vec2(64 * min_range, 64 * max_range)
			_fly_half_way_dist_sqr = global_position.distance_squared_to(_fly_target_position) / 4.0
			animation_player.play("lantern_fly/fly")
		State.WANDER_WALK:
			_wander_walk_timer = randf_range(wander_walk_interval.x, wander_walk_interval.y)
			_wander_direction = Vector2.from_angle(randf_range(0, 2*PI))
			animation_player.play("lantern_fly/walk")
		State.WANDER_WAIT:
			_wait_timer = randf_range(wander_wait_interval.x, wander_walk_interval.y)
			animation_player.play("lantern_fly/idle")


var _star_pattern_speed_modifier: StatMultModifier = StatMultModifier.new(1.5)
var _line_pattern_speed_modifier: StatAbsoluteMultModifier = StatAbsoluteMultModifier.new(0)

func _shoot_pattern():
	var world = World.instance
	match bullet_pattern:
		Pattern.STAR:
			for i in range(4):
				var projectile = bullet_prefab.instantiate() as Projectile
				world.add_child(projectile)
				projectile.construct(global_position, Vector2.from_angle(i / 4.0 * 2 * PI), team.team)
			var offset = deg_to_rad(45)
			for i in range(4):
				var projectile = bullet_prefab.instantiate() as Projectile
				world.add_child(projectile)
				projectile.construct(global_position, Vector2.from_angle(i / 4.0 * 2 * PI + offset), team.team)
				var stat_block = projectile.stat_block as StatBlock
				stat_block.get_stat(Stat.Type.SPEED).add_modifier(_star_pattern_speed_modifier)
		Pattern.RADIAL:
			for i in range(8):
				var projectile = bullet_prefab.instantiate() as Projectile
				world.add_child(projectile)
				projectile.construct(global_position, Vector2.from_angle(i / 8.0 * 2 * PI), team.team)
		Pattern.SHOTGUN:
			var count = 5
			var arc_length = deg_to_rad(60)
			var per_bullet_deg = arc_length / count
			var deg_offset = deg_to_rad(-90)
			for i in range(count):
				var projectile = bullet_prefab.instantiate() as Projectile
				world.add_child(projectile)
				projectile.construct(global_position, Vector2.from_angle(global_rotation + i * per_bullet_deg - arc_length / 2.0  + deg_offset), team.team)
		Pattern.LINE:
			var projectile = bullet_prefab.instantiate() as Projectile
			world.add_child(projectile)
			projectile.construct(global_position, Vector2.ONE, team.team)
			var stat_block = projectile.stat_block as StatBlock
			stat_block.get_stat(Stat.Type.SPEED).add_modifier(_line_pattern_speed_modifier)
	on_shoot.emit()
