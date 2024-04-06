@tool
extends Node
class_name SetThemeVariation


@export var theme_variation: String :
	get:
		return _theme_variation
	set(value):
		_theme_variation = value
		_update_theme_variation()
var _available_theme_variants_hint_string: String

var _theme_variation: String


func _ready():
	_update_theme_variation()


func _validate_property(property):
	if property.name == "theme_variation":
		property.hint = PROPERTY_HINT_ENUM_SUGGESTION
		property.hint_string = _available_theme_variants_hint_string


func _update_theme_variation():
	var parent = get_parent()
	if parent is Control:
		parent.theme_type_variation = _theme_variation
		if not _available_theme_variants_hint_string:
			var theme = parent.theme
			var curr_parent = parent
			while not theme:
				curr_parent = curr_parent.get_parent()
				theme = curr_parent.theme
			var variants_list = theme.get_type_variation_list(parent.get_class())
			_available_theme_variants_hint_string = ",".join(variants_list)
