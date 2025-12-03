extends CanvasLayer

@onready var score: Label = $Panel/Score
@onready var money: Label = $Panel/money
@onready var wave_count: Label = $Panel/wave_count
@onready var enemies_left: Label = $"Panel/Enemies left"
@onready var next_wave: Button = $"Panel/Next Wave"
@onready var lvl_scene = get_tree().get_first_node_in_group("Game_Level")

var is_wave_started:= false

func _ready() -> void:
	get_parent().wave_done.connect(wave_done)

func _process(_delta: float) -> void:
	score.text = str("Score: ", GameManager.Score)
	money.text = str("Mons: ", GameManager.Money)
	wave_count.text = str("Enemies Left: ", get_parent().enemies_to_spawn) 
	enemies_left.text = str("Enemies Left to kill: ", get_parent().enemies_to_die)
	if is_wave_started:
		next_wave.hide()
	else:
		next_wave.show()
	 
	## change the get_parent()^ later to to be more dynamic with the levels

func wave_done():
	is_wave_started = false


func _on_next_wave_pressed() -> void:
	if !is_wave_started:
		get_parent().start_wave()
		is_wave_started = true
		
