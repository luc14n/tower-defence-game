extends Area2D
class_name Tower

@export var projectile: PackedScene
@export var fire_rate:= 1.0
@export var bullet_damage := 1.0
@export var particles: CPUParticles2D
@export var vision: CollisionShape2D
@export var vision_area: Panel
@export var upgrade_panel: Panel
@export var damage_button: Button
@export var range_button: Button
@export var fire_rate_button: Button

@onready var muzzle: Marker2D = $Muzzle
@onready var upgrade_pos: Marker2D = $upgrade_pos

var enemies_seen := []
var time_since_last_shot := 0.0
var can_be_placed: bool

var damage_lvl := 0
var range_lvl := 0
var fire_rate_lvl := 0

func _ready() -> void:
	upgrade_panel.position = upgrade_pos.global_position + Vector2(-88,0)

func _physics_process(delta: float) -> void:
	time_since_last_shot += delta
	
	if enemies_seen:
		look_at(enemies_seen[0].global_position)
	
	if enemies_seen.size() > 0 and time_since_last_shot >= 1.0/ fire_rate:
		shoot(enemies_seen[0])
		time_since_last_shot = 0

func shoot(tar):
	var bullet = projectile.instantiate()
	bullet.set_target(tar)
	bullet.global_position = muzzle.global_position
	bullet.look_at(tar.global_position)
	bullet.damage = bullet_damage
	get_tree().current_scene.add_child(bullet)

func _on_enem_detectection_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		enemies_seen.append(area)

func _on_enem_detectection_area_exited(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		enemies_seen.erase(area)

func _on_upgrade_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		upgrade_panel.show()
	else:
		upgrade_panel.hide()
		

## UPGRADES AND STUFF

func _on_damage_pressed() -> void:
	if GameManager.Money >= 5:
		GameManager.Money -= 5
		damage_lvl += 1
		bullet_damage += .2
		print(bullet_damage)
				

func _on_fire_rate_pressed() -> void:
	if GameManager.Money >= 5:
		GameManager.Money -= 5
		fire_rate_lvl += 1
		fire_rate += .1
		print(fire_rate)

func _on_range_pressed() -> void:
	if GameManager.Money >= 5:
		GameManager.Money -= 5
		range_lvl += 1
		vision.shape.radius += 3
		## Try to show the range via a drawn circle or use the panel and have it move when it upgrades
