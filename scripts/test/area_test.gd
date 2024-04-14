extends Node2D

# NOTE:
# Area entered and exited seems to be buggy when you turn on/off area_2D using monitorable
# (Some events are not firing, and some unexpected events are firing)
#
# Instead you should set the collision shape to disabled or enabled to ensure the correct 
# area_entered and area_exited signals get sent to all the bodies involved.


@onready var area_1: Area2D = get_node("Area2D")
@onready var area_2: Area2D = get_node("Area2D2")
@onready var area_1_collision_shape: CollisionShape2D = get_node("Area2D/CollisionShape2D")
@onready var area_2_collision_shape: CollisionShape2D = get_node("Area2D2/CollisionShape2D")


func _ready():
	area_1.area_entered.connect(_on_area_entered_exited.bind("Area 1", "entered"))
	area_2.area_entered.connect(_on_area_entered_exited.bind("Area 2", "entered"))
	area_1.area_exited.connect(_on_area_entered_exited.bind("Area 1", "exited"))
	area_2.area_exited.connect(_on_area_entered_exited.bind("Area 2", "exited"))
	_print_state()


func _on_area_entered_exited(area: Area2D, name: String, type: String):
	print("%s detected area %s" % [name, type])


func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		print("--------------------------------------------------------------")
		area_1_collision_shape.disabled = not area_1_collision_shape.disabled
		_print_state()
	if Input.is_action_just_pressed("ui_down"):
		print("--------------------------------------------------------------")
		area_2_collision_shape.disabled = not area_2_collision_shape.disabled
		_print_state()


func _print_state():
	print("enabled Area 1: ", not area_1_collision_shape.disabled, " Area 2: ", not area_2_collision_shape.disabled)
