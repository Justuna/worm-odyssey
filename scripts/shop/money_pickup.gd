class_name MoneyPickup
extends Node


signal picked_up(interactor: AutoInteractor)

@export var root: Node
@export var interactable : AutoInteractable
@export var lifetime: float = 10

@export var flicker: Flicker
@export var start_flicker: float = 2

var _inited = false
var _value: int = 10
var _timer: float


func construct(value: int):
	_value = value
	_timer = lifetime
	_inited = true


func _ready():
	interactable.on_interact.connect(_on_interact)


func _process(delta):
	if not _inited:
		return

	_timer -= delta
	if _timer <= start_flicker and not flicker.activated:
		flicker.start()
	if _timer <= 0:
		root.queue_free()


func _on_interact(interactor: AutoInteractor):
	var bank = interactor.get_parent().get_node_or_null("Bank")

	if bank:
		bank.balance += _value
		root.queue_free()
		picked_up.emit(interactor)
