class_name MoneyPickup
extends Node

@export var root: Node
@export var interactable : AutoInteractable

var _value: int

const DEFAULT_VALUE = 5


func _ready():
	interactable.on_interact.connect(_on_interact)
	_value = DEFAULT_VALUE


func _on_interact(interactor: AutoInteractor):
	var bank = interactor.get_parent().get_node_or_null("Bank")

	if bank:
		bank.balance += _value
		root.queue_free()
