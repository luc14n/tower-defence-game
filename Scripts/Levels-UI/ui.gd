extends CanvasLayer

@onready var money: Label = $money
@onready var wave_count: Label = $wave_count
@onready var score: Label = $Score


func _process(_delta: float) -> void:
	score.text = str("Score: ", GameManager.Score)
	money.text = str("Mons: ", GameManager.Money)
	wave_count.text = str("Enemies Left: ", get_parent().enemies_to_spawn) 
	## change the get_parent()^ later to to be more dynamic with the levels
