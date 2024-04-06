extends Node
class_name DroppedEquipment


@export var equipment: Equipment

@export_group("Dependencies")
@export var interactable: Interactable
@export var visuals_container: Node2D


func construct(_equipment: Equipment):
	equipment = _equipment
	visuals_container.add_child(_equipment)
	_equipment.position = Vector2.ZERO


func _ready():
	interactable.on_interact.connect(_on_interact)


func _on_interact(interactor: Interactor):
	var worm_controller = interactor.get_parent().get_node_or_null("WormController") as WormController
	if worm_controller:
		if worm_controller.try_add_equipment(equipment):
			# TODO: Add pickup FX
			queue_free()

