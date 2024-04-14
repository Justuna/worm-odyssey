# An economy that scales polynomially with time.

class_name PolynomialEconomy
extends Economy


@export var coefficient: float = 1
@export var degree: float = 1


func _physics_process(delta):
	super._physics_process(delta)
	value += delta * _earn_rate()


func _earn_rate():
	return coefficient * degree * pow(t, degree - 1)
