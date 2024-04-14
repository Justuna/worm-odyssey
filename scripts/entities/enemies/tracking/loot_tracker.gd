class_name LootTracker
extends Node2D


var loot: Array[Node]
var jitter: Vector2


func _exit_tree():
	while loot.size() > 0:
		var drop = loot.pop_front()
		if drop is Node2D:
			print("Dropping %s" % drop.name)
			
			var pos = get_parent().position
			pos.x += randf_range(-jitter.x, jitter.x)
			pos.y += randf_range(-jitter.y, jitter.y)
			
			World.instance.defer_spawn(drop, pos)
