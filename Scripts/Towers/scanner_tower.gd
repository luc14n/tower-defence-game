extends Tower

func _on_enem_detectection_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		enemies_seen.append(area)

func _on_enem_detectection_area_exited(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		enemies_seen.erase(area)
