@tool
extends ColorRect
class_name EquipmentTextureHolder


@export var texture: Texture2D :
	get:
		return _texture
	set(value):
		_texture = value
		_update_texture_rect()
@export var texture_rect: TextureRect

var _texture: Texture2D


func _ready():
	_update_texture_rect()


func _update_texture_rect():
	if texture_rect:
		texture_rect.texture = _texture
