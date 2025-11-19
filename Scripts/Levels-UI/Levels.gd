extends Node2D

@export var enemie_scenes: Array[PackedScene]
@export var wave_data: Dictionary
@export var enems_each_wave: Array[int]
@export var wave_max: int

@onready var towers: Node2D = $Towers
@onready var lvl_1_path: Path2D = $"Lvl1 path"
@onready var enemy_spawn: Timer = $Timers/EnemySpawn
@onready var wave_cooldown: Timer = $Timers/wave_cooldown
@onready var wave_count:= 1

var Bugs_Excaped := 0
var enemies_to_spawn: int
var enemies_to_die: int
var wave_health_plus:= 0
var wave_speed_plus:= 0

## FLAGS
var is_level_beat := false
var is_stage_beat:= false

func _ready() -> void:
	enemy_spawn.start(randf_range(.5,2.5))
	enemies_to_spawn = enems_each_wave[0]
	enemies_to_die = enemies_to_spawn

func _process(_delta: float) -> void:
	if enemies_to_spawn <= 0:  # stops enemy spawn timer
		enemy_spawn.stop()
	if enemies_to_die <= 0 and !is_level_beat:
		enemy_spawn.stop()
		wave_compleated()
		is_level_beat = true
	if is_stage_beat:
		return

func spawn_enemie():
	var enem = enemie_scenes[0].instantiate()
	enem.Escaped.connect(on_enem_escaped)
	enem.Death.connect(on_enem_death)
	lvl_1_path.add_child(enem)
	enem.health += wave_health_plus
	enem.speed += wave_speed_plus
	print(enem.speed)
	enemy_spawn.start(randf_range(.5,2.5))

func on_enem_escaped():
	enemies_to_die -= 1
	Bugs_Excaped += 1
	if Bugs_Excaped >= 3:
		enemy_spawn.stop()
		print("Game Over!!!")
		get_tree().paused = true

func on_enem_death(amount, score):
	enemies_to_die -= 1
	GameManager.Money += amount
	GameManager.Score += score

func wave_compleated():
	print("Level Beat")
	wave_count += 1
	if wave_count == wave_max:
		print("Stage Compleated!!!")
		wave_cooldown.stop()
		enemy_spawn.stop()
		#get_tree().change_scene_to_file("res://Scenes/Maps and UI/upgrade_shop.tscn")
	else:
		wave_cooldown.start()

func _on_wave_cooldown_timeout() -> void:
	match wave_count:
		2:
			print("Level 2 Starting")
			enemies_to_spawn = enems_each_wave[1]
		3:
			print("Final Level Starting")
			enemies_to_spawn = enems_each_wave[2]
	
	wave_health_plus += 1
	wave_speed_plus += 5
	enemies_to_die = enemies_to_spawn
	enemy_spawn.start(randf_range(.5,2.5))
	is_level_beat = false

func _on_enemy_spawn_timeout() -> void:
	enemies_to_spawn -= 1
	spawn_enemie()


func _on_button_3_pressed() -> void:
	spawn_enemie()
