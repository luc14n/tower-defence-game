extends PathFollow2D
class_name Enemy

signal Escaped

@export var virus_stats : Virus_Stats
@onready var health = virus_stats.max_health

func _physics_process(delta: float) -> void:
	set_progress(progress + virus_stats.speed * delta)	## This makes body follow game path by the stat speed
	if progress_ratio == 1:
		Escaped.emit()
		queue_free()

func _on_enemyarea_body_entered(body: Node2D) -> void:
	if body.is_in_group("Proj"):
		body.queue_free()
		take_damage(body.damage)

func take_damage(dmg):
	health -= dmg
	if health <= 0:
		queue_free()
