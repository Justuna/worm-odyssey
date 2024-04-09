class_name Node2DUtils


static func local_to_global_dir(node: Node2D, dir: Vector2) -> Vector2:
	return node.global_position.direction_to(node.to_global(dir))
