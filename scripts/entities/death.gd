class_name Death
extends Node

@export var entity: Node
@export var death_prefabs: Array[PackedScene]

func die():
    for prefab in death_prefabs:
        var node = prefab.instantiate()
        entity.get_parent().add_child(node)
    entity.queue_free()