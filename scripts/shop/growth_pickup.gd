class_name GrowthPickup
extends Node


signal picked_up(interactor: AutoInteractor)

@export var root: Node
@export var interactable : AutoInteractable
@export var lifetime: float = 10
@export var value: float = 10

@export var flicker: Flicker
@export var start_flicker: float = 2

var _timer: float


func _ready():
	interactable.on_interact.connect(_on_interact)
	_timer = lifetime


func _process(delta):
	_timer -= delta
	if _timer <= start_flicker and not flicker.activated:
		flicker.start()
	if _timer <= 0:
		root.queue_free()


func _on_interact(interactor: AutoInteractor):
	var meter = interactor.get_parent().get_node_or_null("GrowthMeter") as GrowthMeter

	if meter:
		meter.growth_meter.value += value
		root.queue_free()
		picked_up.emit(interactor)
