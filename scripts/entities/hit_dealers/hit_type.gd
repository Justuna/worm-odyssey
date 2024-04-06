# Base class for entities who can damage/heal other entities on contact.

class_name HitType
extends Node

@export var hitbox: HitDetector

@export var damage: int
@export var is_healing: bool
@export var effects: Array[Effect.Type]

signal hit_dealt(node: Node)
