@tool
extends GPUParticles2D


const SCALE_FACTOR: float = 1 / 30.0

enum Mode {
	SCALE,
	EMISSION_RADIUS,
}

@export var range: Stat
@export var mode: Mode = Mode.SCALE


func _ready():
	if Engine.is_editor_hint():
		return
	process_material = process_material.duplicate()
	range.updated.connect(_on_range_updated)
	_on_range_updated()
	set_process(false)


func _on_range_updated():
	match mode:
		Mode.SCALE:
			(process_material as ParticleProcessMaterial).scale_min = range.amount * SCALE_FACTOR * RangeCollisionShape2D.RANGE_FACTOR
			(process_material as ParticleProcessMaterial).scale_max = range.amount * SCALE_FACTOR * RangeCollisionShape2D.RANGE_FACTOR
		Mode.EMISSION_RADIUS:
			var radius = range.amount * RangeCollisionShape2D.RANGE_FACTOR
			(process_material as ParticleProcessMaterial).scale_min = range.amount * 1/40.0 * RangeCollisionShape2D.RANGE_FACTOR
			(process_material as ParticleProcessMaterial).scale_max = range.amount * 1/40.0 * RangeCollisionShape2D.RANGE_FACTOR
			(process_material as ParticleProcessMaterial).emission_ring_radius = radius
			(process_material as ParticleProcessMaterial).emission_ring_inner_radius = radius * 0.5

func _process(delta):
	if Engine.is_editor_hint() and range:
		match mode:
			Mode.SCALE:
				(process_material as ParticleProcessMaterial).scale_min = range.base_amount * SCALE_FACTOR * RangeCollisionShape2D.RANGE_FACTOR
				(process_material as ParticleProcessMaterial).scale_max = range.base_amount * SCALE_FACTOR * RangeCollisionShape2D.RANGE_FACTOR
			Mode.EMISSION_RADIUS:
				var radius = range.base_amount * RangeCollisionShape2D.RANGE_FACTOR
				(process_material as ParticleProcessMaterial).scale_min = range.base_amount * 1/40.0 * RangeCollisionShape2D.RANGE_FACTOR
				(process_material as ParticleProcessMaterial).scale_max = range.base_amount * 1/40.0 * RangeCollisionShape2D.RANGE_FACTOR
				(process_material as ParticleProcessMaterial).emission_ring_radius = radius
				(process_material as ParticleProcessMaterial).emission_ring_inner_radius = radius * 0.5
