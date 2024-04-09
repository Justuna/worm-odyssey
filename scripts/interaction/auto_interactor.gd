extends Node2D
class_name AutoInteractor


@export var debug: bool

@export_category("Dependencies")
@export var interact_area: Area2D

# [AutoInteractable]: bool (Are we listening to this interactable's on_available signal?)
var _auto_interactables: Dictionary


func _ready():
	interact_area.area_entered.connect(_on_area_entered)
	interact_area.area_exited.connect(_on_area_exited)


func _on_area_entered(area: Area2D):
	var interactable = area.get_node_or_null("AutoInteractable") as AutoInteractable
	if interactable:
		if interactable.available:
			interactable.interact(self)
			_auto_interactables[interactable] = false
		else:
			interactable.on_available.connect(interactable.interact.bind(self))
			_auto_interactables[interactable] = true


func _on_area_exited(area: Area2D):
	var interactable = area.get_node_or_null("AutoInteractable") as AutoInteractable
	if interactable in _auto_interactables:
		if _auto_interactables[interactable]:
			interactable.on_available.disconnect(interactable.interact.bind(self))
			_auto_interactables.erase(interactable)
			
