# Defines an area representing an instance of damage.

extends Area2D

@export var damage : int;
# export var effects : ??[];

# Requirements:
    # Detect when moving into a Hurtbox
    # Keep track of Hurtboxes it's hit
    # Apply damage/effect to new Hurtboxes
    # Emit signal that it has hit something