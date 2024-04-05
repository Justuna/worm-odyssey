# Aloe Vera: Item that increases regen after a short duration out of combat.

class_name AloeVeraEffect
extends Effect

const ALOE_VERA_STACK_MODIFIER = 0.1
const ALOE_VERA_TIMER = 2

var modifier = 0
var active = true
var timer: float = 0

func _init():
    effect_type = Effect.Type.ALOE_VERA
    # TODO: Attach _deactivate() to the on_damage signal from the Health component

func _process(delta):
    if timer > 0:
        timer = max(timer - delta, 0)
        if timer == 0:
            active = true

func _deactivate():
    active = false
    timer = ALOE_VERA_TIMER

func _on_stack():
    modifier += ALOE_VERA_STACK_MODIFIER

func _on_unstack():
    modifier -= ALOE_VERA_STACK_MODIFIER