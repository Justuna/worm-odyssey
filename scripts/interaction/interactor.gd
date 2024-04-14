extends Node2D
class_name Interactor


@export var debug: bool

@export_category("Dependencies")
@export var interact_area: Area2D

var closest_interactable: Interactable
var nearby_interactables: Array[Interactable] :
	get:
		var result: Array[Interactable] = []
		result.assign(_nearby_interactables.keys())
		return result

# [Area2D]: null
var _nearby_interactables: Dictionary
var _prev_pos: Vector2
var _prev_rot: float


func _ready():
	interact_area.area_entered.connect(_on_area_entered)
	interact_area.area_exited.connect(_on_area_exited)


func interact_closest():
	if closest_interactable:
		closest_interactable.interact(self)


func _on_area_entered(area: Area2D):
	var interactable = area.get_node_or_null("Interactable")
	if interactable:
		_nearby_interactables[interactable] = null
		_select_closest_interactable()


func _on_area_exited(area: Area2D):
	var interactable = area.get_node_or_null("Interactable")
	if interactable:
		_nearby_interactables.erase(interactable)
		_select_closest_interactable()


## Calculates interactable distance based on how far away it is from the worm head
## scaled by the angle from the front of the head. This means interactable items
## perpendicular or completely behind the worm will be considered last. 
func _calc_interactable_dist(interactable: Interactable) -> float:
	var dist = interactable.global_position.distance_to(interact_area.global_position)
	# Front direction of the head in global space
	var local_up = interact_area.global_transform.basis_xform(Vector2.RIGHT)
	var dir_to_interactable = interactable.global_position - interact_area.global_position
	# DOT PRODUCT:
	# 0 = interactable is perpendicular to the head
	# 1 = interactable is in front of the head
	# -1 = interactable is behind the head
	#
	# ANGLE FACTOR:
	# We clamp the dot product to 0.1 to 0.9, to prevent the angle factor from completely
	# turning into 0 and negating the distance factor.
	# 
	# angle_factor values:
	# 0.1 = interactable is almost straight ahead
	# 0.9 = interactable is perpendicular or behind the worm
	var angle_factor = 1.0 - clamp(local_up.normalized().dot(dir_to_interactable.normalized()), 0.1, 0.9)
	return dist * angle_factor


func _select_closest_interactable():
	var nearby = nearby_interactables
	var closest = null
	if nearby.size() > 0:
		closest = nearby[0]
		var closest_dist = _calc_interactable_dist(nearby[0])
		for interactable in nearby:
			var curr_dist = _calc_interactable_dist(interactable)
			if debug:
				_nearby_interactables[interactable] = "%.3f" % [curr_dist]
			if curr_dist < closest_dist:
				closest = interactable
				closest_dist = curr_dist
	if closest != closest_interactable:
		if closest_interactable:
			closest_interactable.selected = false
		closest_interactable = closest
		if closest_interactable:
			closest_interactable.selected = true


func _process(delta):
	if _prev_pos != interact_area.global_position or _prev_rot != interact_area.global_rotation:
		_prev_pos = interact_area.global_position
		_prev_rot = interact_area.global_rotation
		_select_closest_interactable()
	if debug:
		queue_redraw()


func _draw():
	if debug:
		draw_circle(interact_area.global_position, ((interact_area.get_node("CollisionShape2D") as CollisionShape2D).shape as CircleShape2D).radius, Color(Color.BLUE, 0.1))
		draw_line(interact_area.global_position, interact_area.global_position + interact_area.global_transform.basis_xform(Vector2.RIGHT) * 64, Color.BLUE)
		for interactable: Interactable in nearby_interactables:
			var debug_str = _nearby_interactables[interactable]
			if debug_str:
				draw_string(ThemeDB.fallback_font, interactable.global_position + Vector2(0, -40), debug_str)
