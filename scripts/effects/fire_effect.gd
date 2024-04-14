## Aloe Vera: Item that increases regen after a short duration out of combat.
class_name FireEffect
extends Effect


const FIRE_STACK_MODIFIER = 0.1
const FIRE_TICKS_DURATION = 5
const FIRE_TICK_INTERVAL = 0.5
const FIRE_TICK_DAMAGE = 10

var _ticks_left: int = 0
var _timer: float = 0
var _health: Health

@export var fire_particles: GPUParticles2D


func _on_add():
	_health = effect_holder.get_parent().get_node_or_null("Health")
	fire_particles.reparent(effect_holder.get_parent(), false)
	fire_particles.position = Vector2.ZERO
	fire_particles.emitting = true


func _on_remove():
	fire_particles.emitting = false
	fire_particles.reparent(self)


func _on_stack_changed():
	_ticks_left += FIRE_TICKS_DURATION
	# Stack is meaningless to us
	if stack_amount > 1:
		stack_amount = 1


func _process(delta):
	if _ticks_left > 0 and _timer >= 0:
		_timer -= delta
		if _timer <= 0:
			if is_instance_valid(_health):
				_health.take_damage(FIRE_TICK_DAMAGE)
			_ticks_left -= 1
			_timer = FIRE_TICK_INTERVAL
			if _ticks_left == 0:
				effect_holder.remove_effect(Effect.Type.FIRE)
