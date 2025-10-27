extends CharacterBody2D

@export var speed :float

var target := CharacterBody2D
var damage

func _physics_process(_delta: float) -> void:
	look_at(target.global_position)
	velocity = global_position.direction_to(target.global_position) * speed
	move_and_slide()

func set_target(t):
	target = t
