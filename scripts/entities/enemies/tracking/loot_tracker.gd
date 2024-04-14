class_name LootTracker
extends Node2D


var loot: Array[Node]


func _exit_tree():
    for drop in loot:
        if drop is Node2D:
            World.instance.defer_spawn(drop, get_parent().position)