class_name EnemyTracker
extends Node


func _enter_tree():
    World.instance.enemy_counter += 1


func _exit_tree():
    World.instance.enemy_counter = max(World.instance.enemy_counter - 1, 0)