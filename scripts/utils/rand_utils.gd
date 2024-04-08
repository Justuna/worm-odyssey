class_name RandUtils


static func rand_circle_vec2(dist_min: float = 0, dist_max: float = 128) -> Vector2:
	return rand_arc_vec2(0, 360, dist_min, dist_max)


static func rand_arc_vec2(angle_min: float = 0, angle_max: float = 360, dist_min: float = 0, dist_max: float = 128) -> Vector2:
	return Vector2.from_angle(randf_range(deg_to_rad(angle_min), deg_to_rad(angle_max))) * randf_range(dist_min, dist_max)
