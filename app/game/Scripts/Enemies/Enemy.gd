extends PathFollow2D
class_name Enemy

signal Escaped(damage)
signal Death(worth, score)

@export var virus_stats : Virus_Stats
@export var health_bar : ProgressBar
@export var anim_player : AnimationPlayer
@export var particles: CPUParticles2D

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var health = virus_stats.max_health
@onready var speed = virus_stats.max_speed

func _ready() -> void:
	sprite.material = sprite.material.duplicate()
	sprite.material.set_shader_parameter("flash_on", false)
	health_bar.max_value = health
	
	
func _physics_process(delta: float) -> void:
	health_bar.value = health
	set_progress(progress + speed * delta)	## This makes body follow game path by the stat speed that can 
	if progress_ratio == 1:
		Escaped.emit(virus_stats.damage)
		queue_free()

func _on_enemyarea_body_entered(body: Node2D) -> void:
	if body.is_in_group("Proj"):
		body.queue_free()
		take_damage(body.damage)

func take_damage(dmg)-> void:
	anim_player.play("hit_effect")
	health -= dmg
	if health <= 0:
		particles.emitting = true
		Death.emit(virus_stats.Worth, virus_stats.Score)
		queue_free()
