class_name Death
extends Node2D


signal on_death

@export var enabled: bool = true :
	get:
		return _enabled
	set(value):
		_enabled = value
		if _is_readied:
			set_process(_enabled)
var _enabled: bool = true

@export var use_lifetime: bool
@export var lifetime: float
@export var death_fx: Array[FX]
@export var use_children_fx: bool = true

@onready var _is_readied: bool = true

var _is_dead: bool
var _lifetime_timer: float


func _ready():
	enabled = enabled
	if use_children_fx:
		for child in get_children():
			if child is FX and not death_fx.has(child):
				death_fx.append(child)


func _process(delta):
	if use_lifetime:
		_lifetime_timer += delta
		if _lifetime_timer >= lifetime:
			die()


func set_enabled(_enabled: bool):
	enabled = _enabled


func die():
	if _is_dead:
		return
	_is_dead = true
	on_death.emit()
	for fx in death_fx:
		fx.play()
	get_parent().queue_free()
