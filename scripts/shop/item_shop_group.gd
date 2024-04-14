class_name ItemShopGroup
extends ShopGroup

@export var disguised = false

@export var catalog: ItemLibrary
@export var pickup_prefab: PackedScene

var _pickups: Array[ItemPickup]


func _restock():
	for slot in slots:
		var type = randi() % Item.Type.size() 
		var item = catalog.spawn_item(type as Item.Type)
		var pickup = pickup_prefab.instantiate().get_node_or_null("ItemPickup") as ItemPickup

		pickup.construct(item, disguised)
		pickup.interactable.on_interact.connect(_purchase.bind(pickup))
		pickup.pickup_condition = _can_purchase

		slot.add_child(pickup.root)
		_pickups.append(pickup)
	super._restock()


func _purchase(_interactor: Interactor, purchase: ItemPickup):
	var bank = _interactor.get_parent().get_node("Bank") as Bank
	_restock_timer = restock_time
	bank.balance -= current_cost

	for pickup in _pickups:
		if pickup == purchase:
			continue
		pickup.root.queue_free()

	_pickups.clear()
