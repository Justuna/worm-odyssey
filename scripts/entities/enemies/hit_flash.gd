class_name HitFlash
extends Node


@export var health: Health
@export var fill_parameter: String = "overlay_2_amount"

func _ready():
	health.on_damage.connect(_on_damage.unbind(1))
	(get_parent() as Node2D).material = (get_parent() as Node2D).material.duplicate()


func _on_damage():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_method(_set_flash, 1.0, 0.0, 0.5)


func _set_flash(amount: float):
	(get_parent() as Node2D).material.set_shader_parameter(fill_parameter, amount)
