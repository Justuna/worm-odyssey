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
		var pickup = pickup_prefab.instantiate() as ItemPickup

		pickup.construct(item, disguised)
		pickup.interactable.on_interact.connect(_purchase.bind(pickup))

		slot.add_child(pickup)
		_pickups.append(pickup)
	super._restock()


func _make_available():
	for pickup in _pickups:
		pickup.interactable.available = true


func _make_unavailable():
	for pickup in _pickups:
		pickup.interactable.available = false


func _purchase(purchase: ItemPickup):
	_restock_timer = restock_time

	for pickup in _pickups:
		if pickup == purchase:
			continue
		pickup.queue_free()

	_pickups.clear()
