extends Panel
class_name TankPanel

#const TILE_SIZE := Vector2(32,32)

@export var display_tower : PackedScene
@export var worth : float

func _on_gui_input(event: InputEvent) -> void:
	var tower = display_tower.instantiate()
	var tilemap = get_tree().get_first_node_in_group("TileMap")
	var cell = tilemap.local_to_map(event.global_position)
	var data : TileData = tilemap.get_cell_tile_data(cell)
	if !data: return
	var enem_path_flag : bool = data.get_custom_data("EnemPath")
	
	if event is InputEventMouseButton and event.button_mask == 1:		# left mouse down
		if GameManager.Money >= worth:
			add_child(tower)
			tower.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			print("Broke BOI BOI BOI BOI")
			return
			
	elif event is InputEventMouseMotion and event.button_mask == 1:		# CLick and Drag
		if GameManager.Money >= worth:
			if get_child_count() > 1:
				get_child(1).global_position = event.global_position 
			if get_child(1).vision_area:
				if !enem_path_flag:			# Placable Area
					get_child(1).vision_area.modulate = Color(1.0, 1.0, 1.0, 1.0)
				else:
					get_child(1).vision_area.modulate = Color(1.0, 0.0, 0.0, 1.0)
	elif event is InputEventMouseButton and event.button_mask == 0:		# left mouse up
		if !event.global_position.y >= 285:	 # UI length
			if GameManager.Money >= worth:
				if get_child_count() > 1:
					get_child(1).queue_free()
				if !enem_path_flag:		# correct spot
						var tow_container = get_tree().get_first_node_in_group("Game_Level").get_node("Towers")
						GameManager.Money -= worth
						tower.global_position = event.global_position
						tow_container.add_child(tower)
						tower.particles.emitting = true
						tower.vision_area.hide()
						if get_child(1):
							match get_child(1).stats.name:
								"normal":
									worth += 1
								"zap":
									worth += 2
								"snipe":
									worth += 3
				else:					# Wrong Spot
					print("CANT PLACE")
		else:
			if get_child_count() > 1:
				get_child(1).queue_free()
				return
	else:
		if get_child_count() > 1:
				get_child(1).queue_free()
				return
