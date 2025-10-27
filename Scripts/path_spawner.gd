extends Node2D

@onready var lvl1path = preload("uid://djb5esn13lrvh")

func _on_timer_timeout() -> void:
	var path = lvl1path.instantiate()
	add_child(path)
