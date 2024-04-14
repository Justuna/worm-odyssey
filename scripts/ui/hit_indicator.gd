class_name HitIndicator
extends Node2D


@export var label: Label

@export var lifetime: float
@export var base_speed: float
@export var acceleration: Curve
@export var opacity: Curve

var _t = 0


func construct(amount: int, color: Color):
	label.modulate = color

	if amount > 1000000:
		var display_amount: float = (amount as float) / 1000000
		label.text = "%sM" % snappedf(display_amount, 0.1)
	elif amount > 1000:
		var display_amount: float = (amount as float) / 1000
		label.text = "%sK" % snappedf(display_amount, 0.1)
	else:
		label.text = "%s" % amount


func _process(delta):
	_t += delta / lifetime

	var speed = base_speed * acceleration.sample(_t)
	var alpha = opacity.sample(_t)

	label.modulate.a = alpha
	position += Vector2.UP * speed * delta

	if _t >= 1:
		queue_free()