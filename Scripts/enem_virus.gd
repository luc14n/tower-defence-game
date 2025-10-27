extends CharacterBody2D

@export var virus_stats : Virus_Stats


func _physics_process(delta: float) -> void:
	get_parent().set_progress(get_parent().get_progress() + virus_stats.speed * delta)				## This makes body follow game path by the stat speed
	if get_parent().get_progress_ratio() == 1:
		queue_free()


func _on_hurtarea_body_entered(body: Node2D) -> void:
	if body.is_in_group("Proj"):
		body.queue_free()
		take_damage(body.damage)

func take_damage(dmg):
	virus_stats.health -= dmg
	if virus_stats.health <= 0:
		queue_free()
