class_name EquipmentPickup
extends Pickup


var _equipment: Equipment


func construct(equipment: Equipment, disguised = false):
	_equipment = equipment
	visuals_container.add_child(_equipment)
	_equipment.position = Vector2.ZERO
	_equipment.rotation = 0
	_equipment.direction = Equipment.Direction.RIGHT

	if disguised:
		disguise.visible = true
		_equipment.visible = false


func _ready():
	interactable.on_interact.connect(_on_interact)


func _on_interact(interactor: Interactor):
	var worm_controller = interactor.get_parent().get_node_or_null("WormController") as WormController

	if worm_controller:
		if pickup_condition.call() and worm_controller.try_add_equipment(_equipment):
			_equipment.visible = true
			picked_up.emit()
			root.queue_free()

