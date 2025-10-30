extends Control

@onready var Towers : Array = $"../Towers".get_children()
var tower_count: Array

func _process(_delta: float) -> void:
	tower_count = get_tree().get_nodes_in_group("Towers")

func _on_button_pressed() -> void:
	pass
		
