class_name ItemPickup
extends Pickup


var _item: Item


func construct(item: Item, disguised = false):
	_item = item
	visuals_container.add_child(_item)
	
	if disguised:
		disguise.visible = true
		_item.visible = false


func _ready():
	interactable.on_interact.connect(_on_interact)


func _on_interact(interactor: Interactor):
	var item_holder = interactor.get_parent().get_node_or_null("ItemHolder") as ItemHolder
	if item_holder and pickup_condition.call(interactor):
		item_holder.add_item(_item.type)
		picked_up.emit()
		root.queue_free()
