class_name WormBankDisplay
extends Node


@export var worm: Node2D
@export var balance_label: Label

@onready var bank: Bank = worm.get_node("Bank") as Bank

var _tween: Tween


func _ready():
	bank.balance_changed.connect(_update_balance_visuals.unbind(1))
	_update_balance_visuals(false)


func _update_balance_visuals(animate: bool = true):
	balance_label.text = str(bank.balance)
	if _tween and _tween.is_running():
		_tween.kill()
	if animate:
		_tween = create_tween()
		_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		balance_label.scale = Vector2.ONE * 1.5
		_tween.tween_property(balance_label, "scale", Vector2.ONE, 0.5)
