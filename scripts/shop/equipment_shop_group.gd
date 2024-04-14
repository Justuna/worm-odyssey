class_name EquipmentShopGroup
extends ShopGroup

@export var disguised = false

@export var catalog: EquipmentLibrary
@export var pickup_prefab: PackedScene

var _pickups: Array[EquipmentPickup]


func _restock():
	for slot in slots:
		var equipment = catalog.spawn_equipment(catalog.equipment_types.pick_random())
		var pickup = pickup_prefab.instantiate().get_node_or_null("EquipmentPickup") as EquipmentPickup

		pickup.construct(equipment, disguised)
		pickup.picked_up.connect(_purchase.bind(pickup))
		pickup.pickup_condition = _can_purchase

		slot.add_child(pickup.root)
		_pickups.append(pickup)
	super._restock()


func _purchase(interactor: Interactor, purchase: EquipmentPickup):
	var bank = interactor.get_parent().get_node("Bank") as Bank
	_restock_timer = restock_time
	bank.balance -= current_cost

	for pickup in _pickups:
		if pickup == purchase:
			continue
		pickup.root.queue_free()

	_pickups.clear()
