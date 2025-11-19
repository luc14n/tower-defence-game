extends Panel
class_name TankPanel

#const TILE_SIZE := Vector2(32,32)

@export var display_tower : PackedScene
@export var worth : int

func _on_gui_input(event: InputEvent) -> void:
	var tower = display_tower.instantiate()
	var tilemap = get_tree().get_first_node_in_group("TileMap")
	var cell = tilemap.local_to_map(event.global_position)
	var data : TileData = tilemap.get_cell_tile_data(cell)
	if !data: return
	var enem_path_flag : bool = data.get_custom_data("EnemPath")
	var placement_flag = tower.can_be_placed
	placement_flag = enem_path_flag
	
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
			if placement_flag:		#CHANGE COLOR OF AREA IF NOT PLACEABLE
				pass
			else:
				pass
	elif event is InputEventMouseButton and event.button_mask == 0:		# left mouse up
		if GameManager.Money >= worth:
			if get_child_count() > 1:
				get_child(1).queue_free()
			if !enem_path_flag:		# correct spot
					var path = get_tree().get_root().get_node("Main/Towers")
					GameManager.Money -= worth
					tower.global_position = event.global_position
					path.add_child(tower)
					tower.particles.emitting = true
					tower.vision_area.hide()
			else:					# Wrong Spot
				print("CANT PLACE")
	else:
		if get_child_count() > 1:
				get_child(1).queue_free()
				return
