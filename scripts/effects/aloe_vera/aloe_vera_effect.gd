# Aloe Vera: Item that increases regen after a short duration out of combat.

class_name AloeVeraEffect
extends Effect

const ALOE_VERA_STACK_MODIFIER = 0.1
const ALOE_VERA_TIMER = 2

var modifier = 0
var active = true
var _timer: float = 0

func _init():
    effect_type = Effect.Type.ALOE_VERA
    (effect_holder.target.get_node("Health") as Health).on_damage.connect(_deactivate)

func _process(delta):
    if _timer > 0:
        _timer = max(_timer - delta, 0)
        if _timer == 0:
            active = true

func _deactivate():
    active = false
    _timer = ALOE_VERA_TIMER

func _on_stack():
    modifier += ALOE_VERA_STACK_MODIFIER

func _on_unstack():
    modifier -= ALOE_VERA_STACK_MODIFIER