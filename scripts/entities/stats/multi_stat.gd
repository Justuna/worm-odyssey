@tool
@icon("res://assets/art/editor_icons/icon_file_list.svg")
class_name MultiStat
extends Stat


const MULTIPLIER_SCALE: float = 1 / 100.0


@export var base_stat: Stat :
	get:
		return _base_stat
	set(value):
		_base_stat = value
		if Engine.is_editor_hint():
			var key = Type.find_key(base_stat.type) as String
			name = "MultiStat_" + key.to_pascal_case()
var _base_stat: Stat
@export var mult_stats: Array[Stat]


func _ready():
	if Engine.is_editor_hint():
		return
	base_stat = base_stat
	base_stat.updated.connect(_update_amount)
	for i in range(mult_stats.size()):
		mult_stats[i].updated.connect(_update_amount)
	_update_amount()
	# Make the source state the base_stat
	source_stat = base_stat
	super._ready()


func _update_amount():
	var total_weight: int = 0
	var total_mult: float = 0
	var amount: int = 0
	for stat in mult_stats:
		total_mult += stat.amount * MULTIPLIER_SCALE
	amount = base_stat.amount * total_mult
	updated.emit()


func _validate_property(property):
	if property.name in ["type", "base_amount"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
