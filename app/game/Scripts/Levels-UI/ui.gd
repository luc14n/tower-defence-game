extends CanvasLayer

@onready var score: Label = $Panel/Score
@onready var money: Label = $Panel/money
@onready var wave_num: Label = $"Panel/Wave Num"
@onready var next_wave: Button = $"Panel/Next Wave"
@onready var retry: Button = $Panel/Retry
@onready var cpu_health: Label = $"Panel/Cpu Health"
@onready var lvl_scene = get_tree().get_first_node_in_group("Game_Level")

var is_wave_started:= false
var is_game_over:= false

func _ready() -> void:
	get_parent().wave_done.connect(wave_done)
	get_parent().game_lost.connect(game_lost)

func _process(_delta: float) -> void:
	score.text = str("Score: ", GameManager.Score)
	money.text = str("Money: $", GameManager.Money)
	wave_num.text = str("Wave ", get_parent().wave_count)
	cpu_health.text = str("CPU HEALTH - ", get_parent().cpu.health)
	
	if !is_game_over:
		retry.hide()
	else:
		retry.show()
		
	if is_wave_started:
		next_wave.hide()
	else:
		next_wave.show()
	 
	## change the get_parent()^ later to to be more dynamic with the levels

func wave_done():
	is_wave_started = false

func game_lost():
	is_game_over = true


func _on_next_wave_pressed() -> void:
	if !is_wave_started:
		get_parent().start_wave()
		is_wave_started = true


func _on_retry_pressed() -> void:
	if is_game_over:
		get_parent().get_tree().change_scene_to_file("res://Scenes/Maps and UI/lvl_1.tscn")
		is_game_over = false
