extends Node2D

# NOTE:
# Area entered and exited seems to be buggy when you turn on/off area_2D using monitorable


@onready var area_1: Area2D = get_node("Area2D")
@onready var area_2: Area2D = get_node("Area2D2")


func _ready():
	area_1.area_entered.connect(_on_area_entered_exited.bind("Area 1", "entered"))
	area_2.area_entered.connect(_on_area_entered_exited.bind("Area 2", "entered"))
	area_1.area_exited.connect(_on_area_entered_exited.bind("Area 1", "exited"))
	area_2.area_exited.connect(_on_area_entered_exited.bind("Area 2", "exited"))
	print("monitoring Area 1: ", area_1.monitoring, " Area 2: ", area_2.monitoring)


func _on_area_entered_exited(area: Area2D, name: String, type: String):
	print("%s detected area %s" % [name, type])


func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		print("--------------------------------------------------------------")
		area_1.monitoring = not area_1.monitoring
		area_1.monitorable = not area_1.monitorable
		print("monitoring Area 1: ", area_1.monitoring, " Area 2: ", area_2.monitoring)
	if Input.is_action_just_pressed("ui_down"):
		print("--------------------------------------------------------------")
		area_2.monitoring = not area_2.monitoring
		area_2.monitorable = not area_2.monitorable
		print("monitoring Area 1: ", area_1.monitoring, " Area 2: ", area_2.monitoring)
