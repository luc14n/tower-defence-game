extends Control

@export var Stage = Node2D
@onready var Towers := get_tree().get_nodes_in_group("Towers")

var tower_count

func _process(_delta: float) -> void:
	tower_count = get_tree().get_nodes_in_group("Towers")

func _on_button_pressed() -> void:
	for i in tower_count.size():
		tower_count[i].queue_free()


func _on_button_2_pressed() -> void:
	GameManager.Money += 25

func _on_button_3_pressed() -> void:
	Stage.spawn_enemie()
