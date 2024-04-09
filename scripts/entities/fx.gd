## Node that represents visual/audio FX
class_name FX
extends Node2D


signal on_play

@export var entity: Node2D
@export var particles: Array[GPUParticles2D] = []
@export var advanced_particles: Array[AdvancedGPUParticles2D] = []
@export var audio_players: Array[AudioStreamPlayer] = []
@export var audio_players_2D: Array[AudioStreamPlayer2D] = []
@export var animation_players: Array[AnimationPlayer] = []

## Looks in children nodes to populate particles, audio_players, and other node arrys.
@export var use_children: bool = true
## Reparents this node to the grandparent on play
## Useful for death FX, when the parent is about to free itself 
## and we want the FX to play without being freed.
@export var unparent_on_play: bool
## Plays the FX on ready
@export var play_on_ready: bool
## If enabled, after the FX is played, it will free itself after a set duration.
## This "lifetime duration" is controlled by the lifetime variable.
@export var use_lifetime: bool

@export var lifetime: float

var _lifetime_timer: float = 0
var _is_playing: bool


func _ready():
	if use_children:
		for child in get_children():
			if child is AdvancedGPUParticles2D and not advanced_particles.has(child):
				advanced_particles.append(child)
			elif child is GPUParticles2D and not particles.has(child):
				particles.append(child)
			elif child is AudioStreamPlayer and not audio_players.has(child):
				audio_players.append(child)
			elif child is AudioStreamPlayer2D and not audio_players_2D.has(child):
				audio_players_2D.append(child)
			elif child is AnimationPlayer and not animation_players.has(child):
				animation_players.append(child)
				
	if play_on_ready:
		play()


func play():
	if use_lifetime and _is_playing:
		return
	_lifetime_timer = lifetime
	_is_playing = true
	if unparent_on_play:
		reparent(entity.get_parent())
	for advanced_particle in advanced_particles:
		advanced_particle.play()
	for particle in particles:
		particle.emitting = true
	for audio_player in audio_players:
		audio_player.play()
	for animation_player in animation_players:
		animation_player.play()
	on_play.emit()


func _process(delta):
	if use_lifetime and _is_playing:
		_lifetime_timer -= delta
		if _lifetime_timer <= 0:
			queue_free()
