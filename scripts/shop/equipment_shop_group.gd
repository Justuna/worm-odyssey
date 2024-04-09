class_name EquipmentShopGroup
extends ShopGroup

@export var disguised = false

@export var catalog: EquipmentLibrary
@export var pickup_prefab: PackedScene

var _pickups: Array[EquipmentPickup]


func _restock():
	for slot in slots:
		var type = randi() % Equipment.Type.size() 
		var equipment = catalog.spawn_equipment(type as Equipment.Type)
		var pickup = pickup_prefab.instantiate().get_node_or_null("EquipmentPickup") as EquipmentPickup

		pickup.construct(equipment, disguised)
		pickup.interactable.on_interact.connect(_purchase.bind(pickup))

		slot.add_child(pickup.root)
		_pickups.append(pickup)
	super._restock()


func _make_available():
	super._make_available()
	for pickup in _pickups:
		pickup.interactable.available = true


func _make_unavailable():
	super._make_unavailable()
	for pickup in _pickups:
		pickup.interactable.available = false


func _purchase(_interactor: Interactor, purchase: EquipmentPickup):
	_restock_timer = restock_time
	_bank.balance -= current_cost

	for pickup in _pickups:
		if pickup == purchase:
			continue
		pickup.root.queue_free()

	_pickups.clear()
