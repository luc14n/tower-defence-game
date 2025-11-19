extends PathFollow2D
class_name Enemy

signal Escaped
signal Death(worth, score)

@export var virus_stats : Virus_Stats
@export var health_bar : ProgressBar
@onready var health = virus_stats.max_health
@onready var speed = virus_stats.speed

func _ready() -> void:
	health_bar.max_value = virus_stats.max_health

func _physics_process(delta: float) -> void:
	health_bar.value = health
	set_progress(progress + speed * delta)	## This makes body follow game path by the stat speed that can 
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
		Death.emit(virus_stats.Worth, virus_stats.Score)
		queue_free()
