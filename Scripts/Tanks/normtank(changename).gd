extends StaticBody2D

@export var fire_rate:= 1.0
@export var bullet_damage := 1.0

@onready var projectile = preload("uid://dnv8q0jdyqo07")
@onready var muzzle: Marker2D = $Muzzle


var enemies_seen := []
var time_since_last_shot := 0.0


func _physics_process(delta: float) -> void:
	time_since_last_shot += delta
	if enemies_seen:
		look_at(enemies_seen[0].global_position)
	
	if enemies_seen.size() > 0 and time_since_last_shot >= 1.0/ fire_rate:
		shoot(enemies_seen[0])
		time_since_last_shot = 0

func shoot(tar):
	var bullet = projectile.instantiate()
	bullet.global_position = muzzle.global_position
	bullet.look_at(tar.global_position)
	bullet.damage = bullet_damage
	get_tree().current_scene.add_child(bullet)
	bullet.set_target(tar)


func _on_enem_detectection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		enemies_seen.append(body)
		
func _on_enem_detectection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		enemies_seen.erase(body)
