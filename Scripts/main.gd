extends Node2D

const ENEMY = preload("uid://u1d2le8te1px")
@onready var towers: Node2D = $Towers
@onready var lvl_1_path: Path2D = $"Lvl1 path"
@onready var timer: Timer = $Timer

var Bugs_Excaped := 0

func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	var enem = ENEMY.instantiate()
	enem.Escaped.connect(on_enem_escaped)
	lvl_1_path.add_child(enem)

func on_enem_escaped():
	Bugs_Excaped += 1
	if Bugs_Excaped >= 3:
		timer.stop()
		print("Game Over!!!")
