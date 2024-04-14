class_name DamageInstanceListener
extends Node


signal on_damage_pre(instance: DamageInstance, health: Health)
signal on_damage_post(instance: DamageInstance, health: Health)


func notify_pre_damage(instance: DamageInstance, health: Health):
	on_damage_pre.emit(instance, health)


func notify_post_damage(instance: DamageInstance, health: Health):
	on_damage_post.emit(instance, health)
