extends Node2D
class_name Level

signal wave_done
signal game_lost

@export var enem_particles: CPUParticles2D
@export var enemie_scenes: Array[PackedScene]
@export var enems_each_wave: Array[int]
@export var wave_max: int
@export var wave_count:= 0
@export var cpu: Button

@onready var towers: Node2D = $Towers
@onready var enemy_path: Path2D = $"Enemy Path"
@onready var enemy_spawn: Timer = $Timers/EnemySpawn
@onready var wave_cooldown: Timer = $Timers/wave_cooldown

@onready var Bugs_Excaped := 0
@onready var wave_health_plus: float = 0
@onready var wave_speed_plus: float = 0
@onready var spawn_time := 2.0
var enemies_to_spawn: int
var enemies_to_die: int
var enem_picker:= 1

## FLAGS
@onready var is_wave_started := false 
@onready var is_boss_fight_started := false
@onready var is_level_beat := false
@onready var is_stage_beat := false
@onready var lose_level:= false

func _ready() -> void:
	GameManager.Money = 10
	GameManager.Score = 0
	$sfx/Mania.playing = true
	cpu.Dead.connect(base_death)

func _process(_delta: float) -> void:
	if enemies_to_spawn <= 0:  # stops enemy spawn timer
		enemy_spawn.stop()
	if enemies_to_die <= 0 and !is_level_beat and !lose_level and is_wave_started: # checking if level is won
		print("Level Beat")
		enemy_spawn.stop()
		wave_compleated()
		is_level_beat = true
		wave_done.emit()
	#if is_stage_beat:
		#return

func spawn_enemie() -> void:
	var enem = enemie_scenes[enem_picker].instantiate()
	enem.Escaped.connect(on_enem_escaped)
	enem.Death.connect(on_enem_death)
	if !is_boss_fight_started:		# switching emeies per wave
		if wave_count == 1:
			enem_picker = 1
		elif wave_count == 2:
			enem_picker = 0
		elif wave_count >= 3: #Swapping enemies
			if enem_picker <= 0:
				enem_picker = 1
			elif enem_picker >= 1:
				enem_picker = 0
		enemy_path.add_child(enem)
		enem.health += wave_health_plus
		enem.speed += wave_speed_plus
		enemy_spawn.start(spawn_time)
	else:
		enemies_to_spawn -= 1
		enemy_path.add_child(enem)

func on_enem_escaped(dmg: float)-> void:
	$sfx/EnemEscaped.playing = true
	if !lose_level:
		enemies_to_die -= 1
		cpu.take_dam(dmg)

func base_death():	#called via cpu signal
	# try to make a loss condition or sum
	game_lost.emit()
	$sfx/GameOver.playing = true
	enemy_spawn.stop()
	wave_cooldown.stop()
	lose_level = true
	
	print("Game Over")

func on_enem_death(amount: float, score: int, pos: Vector2)-> void:
	$sfx/EnemHit.playing = true
	enemies_to_die -= 1
	GameManager.Money += amount
	GameManager.Score += score
	enem_particles.position = pos
	enem_particles.emitting = true

func wave_compleated()-> void:
	if !lose_level:
		wave_count += 1
		if !is_boss_fight_started and !wave_count == wave_max: 
			if wave_count == wave_max - 1:						# Start Boss fight
				print("BOSS UP NEXT!")
				is_boss_fight_started = true
		else:													# Stage Done
			match name:
				"lvl_1":
					get_tree().change_scene_to_file("res://Scenes/Maps and UI/lvl_2.tscn")
				"lvl_2":
					get_tree().change_scene_to_file("res://Scenes/Maps and UI/lvl_3.tscn")

func start_wave():
	print("Wave Started, wave count: ", wave_count)
	enemies_to_spawn = enems_each_wave[wave_count]
	enemies_to_die = enemies_to_spawn
	is_wave_started = true
	spawn_time -= .1
	print("spawn time: ", spawn_time)
	if !is_boss_fight_started:
		if wave_count >= 1:
			wave_health_plus += 1
			wave_speed_plus += 5.5
		elif wave_count >= 3:
			wave_health_plus += 1
			wave_speed_plus += 5.5
		elif wave_count >= 7:
			wave_health_plus += 2.5
			wave_speed_plus += 5.5
		enemy_spawn.start(spawn_time)
		is_level_beat = false
	else:
		enem_picker = 2
		is_level_beat = false
		spawn_enemie()


func _on_wave_cooldown_timeout() -> void:
	print("cooldown ended")
	start_wave()

func _on_enemy_spawn_timeout() -> void:
	enemies_to_spawn -= 1
	spawn_enemie()
