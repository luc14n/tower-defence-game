extends CharacterBody2D
class_name Projectile

@export var speed :float

var damage : float
var target := CharacterBody2D

func _physics_process(_delta: float) -> void:
	if target:
		look_at(target.global_position)
		velocity = global_position.direction_to(target.global_position) * speed
	move_and_slide()

func set_target(t)-> void:
	target = t

func _on_timer_timeout() -> void:
	queue_free()
