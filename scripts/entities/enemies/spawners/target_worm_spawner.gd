class_name TargetWormSpawner
extends Spawner


@export var worm: Node2D
@export var max_spawn_attempts: int = 20

func _place_enemy(enemy: Node, card: EnemyCard):
	if enemy is Node2D:
		if not is_instance_valid(worm):
			# print("No head?")
			enemy.queue_free()
			return
			
		var worm_controller = worm.get_node("WormController") as WormController
		var head = worm_controller.head_segment
		for _i in range(max_spawn_attempts):
			var dist = lerp(card.max_preferred_distance, card.min_preferred_distance, pow(randf_range(0, 1), 2))
			var angle = randf_range(0, TAU)

			var vector = Vector2.RIGHT.rotated(angle) * dist
			var position: Vector2 = head.position + vector

			var query = PhysicsPointQueryParameters2D.new()
			query.position = position

			var intersections = World.instance.get_world_2d().direct_space_state.intersect_point(query)
			if intersections.size() == 0:
				World.instance.add_child(enemy)
				enemy.position = position
				return
			else:
				for intersection in intersections:
					# print("Intersected with %s" % intersection["collider"].name)
					pass
		# print("Ran out of attempts")
	else:
		# print("Enemy does not exist in space??")
		pass

	enemy.queue_free()
