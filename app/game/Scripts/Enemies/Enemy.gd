extends PathFollow2D
class_name Enemy

signal Escaped(damage)
signal Death(worth, score, pos)

@export var virus_stats : Virus_Stats
@export var anim_player : AnimationPlayer

@onready var center_pos: Marker2D = $center_pos
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var health = virus_stats.max_health
@onready var speed = virus_stats.max_speed
@onready var enem_hit: AudioStreamPlayer = $EnemHit

func _ready() -> void:
	sprite.material = sprite.material.duplicate()
	sprite.material.set_shader_parameter("flash_on", false)
	
	
func _physics_process(delta: float) -> void:
	set_progress(progress + speed * delta)	## This makes body follow game path by the stat speed that can 
	if progress_ratio == 1:
		Escaped.emit(virus_stats.damage)
		queue_free()

func _on_enemyarea_body_entered(body: Node2D) -> void:
	if body.is_in_group("Proj"):
		body.queue_free()
		take_damage(body.damage)

func take_damage(dmg)-> void:
	enem_hit.play()
	anim_player.play("hit_effect")
	health -= dmg
	if health <= 0:
		Death.emit(virus_stats.Worth, virus_stats.Score, center_pos.global_position)
		queue_free()
