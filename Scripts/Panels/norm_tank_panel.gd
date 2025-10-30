extends Panel
class_name TankPanel

@export var display_tower : PackedScene

func _on_gui_input(event: InputEvent) -> void:
	var tower = display_tower.instantiate()
	if event is InputEventMouseButton and event.button_mask == 1:		# left mouse down
		add_child(tower)
		tower.process_mode = Node.PROCESS_MODE_DISABLED
	elif event is InputEventMouseMotion and event.button_mask == 1:		# CLick and Drag
		get_child(1).global_position = event.global_position
	elif event is InputEventMouseButton and event.button_mask == 0:		# left mouse up
		if !get_child(1):
			return
		get_child(1).queue_free()
		if event.global_position.y < 136:
			get_child(1).queue_free()
		else:
			var path = get_tree().get_root().get_node("Main/Towers")
			tower.global_position = event.global_position * 2
			path.add_child(tower)
