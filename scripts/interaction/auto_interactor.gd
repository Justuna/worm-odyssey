extends Node2D
class_name AutoInteractor


@export var debug: bool

@export_category("Dependencies")
@export var interact_area: Area2D

# [AutoInteractable]: null
var _auto_interactables: Dictionary


func _ready():
	interact_area.area_entered.connect(_on_area_entered)
	interact_area.area_exited.connect(_on_area_exited)


func _on_area_entered(area: Area2D):
	var interactable = area.get_node_or_null("AutoInteractable") as AutoInteractable
	if interactable:
		interactable.interact(self)
		_auto_interactables[interactable] = false


func _on_area_exited(area: Area2D):
	var interactable = area.get_node_or_null("AutoInteractable") as AutoInteractable
	if interactable in _auto_interactables:
		if _auto_interactables[interactable]:
			_auto_interactables.erase(interactable)
			
