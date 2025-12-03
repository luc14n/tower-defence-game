extends Area2D
class_name Tower

@export var projectile: PackedScene
@export var bullet_damage := 1.0
@export var fire_rate:= 1.0
@export var particles: CPUParticles2D
@export var vision: CollisionShape2D
@export var vision_area: Panel
@export var upgrade_panel: Panel
@export var damage_button: Button
@export var range_button: Button
@export var fire_rate_button: Button
@export var muzzle: Marker2D

@onready var upgrade_pos: Marker2D = $upgrade_pos

var enemies_seen := []
var time_since_last_shot := 0.0
var can_be_placed: bool
var damage_lvl := 0
var fire_rate_lvl := 0
var range_lvl := 0
var damage_price:= 5.0
var fire_rate_price:= 5.0
var range_price:= 5.0

func _ready() -> void:
	upgrade_panel.position = upgrade_pos.global_position + Vector2(-88,0)

func _physics_process(delta: float) -> void:
	time_since_last_shot += delta
	damage_button.text = str("Damage\n","lvl: ",damage_lvl,"\n","$ ",damage_price)
	fire_rate_button.text = str("Fire Rate\n","lvl: ",fire_rate_lvl,"\n","$ ",fire_rate_price)
	range_button.text = str("Range\n","lvl: ",range_lvl,"\n","$ ",range_price)
	
	if enemies_seen:
		look_at(enemies_seen[0].global_position)
	
	if enemies_seen.size() > 0 and time_since_last_shot >= 1.0/ fire_rate:
		shoot(enemies_seen[0])
		time_since_last_shot = 0

func shoot(tar)-> void:
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
		vision_area.show()
	else:
		upgrade_panel.hide()
		vision_area.hide()

## UPGRADES AND STUFF

func _on_damage_pressed() -> void:
	if !damage_lvl >= 10:
		if GameManager.Money >= damage_price:
			GameManager.Money -= damage_price
			damage_price += 10
			damage_lvl += 1
			bullet_damage += .5
			print(name," Bullet Damage: ",bullet_damage)
		else:
			print("YOU BROKE NIGGA")
	else:
		print("MAX LEVEL")

func _on_fire_rate_pressed() -> void:
	if !fire_rate_lvl >= 10:
		if GameManager.Money >= fire_rate_price:
			GameManager.Money -= fire_rate_price
			fire_rate_price += 10
			fire_rate_lvl += 1
			fire_rate += .3
			print(name," Fire rate: ",fire_rate)
		else:
			print("YOU BROKE NIGGA")
	else:
		print("MAX LEVEL")

func _on_range_pressed() -> void:
	if !range_lvl >= 10:
		if GameManager.Money >= range_price:
			GameManager.Money -= range_price
			range_price += 10
			range_lvl += 1
			vision.shape.radius += 3
			print(name," Range: ",vision.shape.radius)
			## Try to show the range via a drawn circle or use the panel and have it move when it upgrades
		else:
			print("YOU BROKE NIGGA")
	else:
		print("MAX LEVEL")
