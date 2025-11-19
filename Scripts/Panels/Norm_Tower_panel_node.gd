extends Control
class_name Tank_Panel_Node

@export var Pannel : TankPanel

@onready var cost: Label = $Cost

func _process(_delta: float) -> void:
	cost.text = str("$", Pannel.worth)
