extends Button

signal Dead

@export var max_health: float
@onready var health := max_health

func take_dam(dmg) -> void:
	health -= dmg
	print(health)
	if health <= 0:
		Dead.emit()
