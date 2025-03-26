extends CanvasLayer

@export var experience_manager: Node

@onready var label: Label = $MarginContainer/Label

var current_level_display = 1


func _ready():
	experience_manager.level_up.connect(on_level_up)
	label.text = str(current_level_display)


func on_level_up(current_level: int):
	current_level_display = current_level
	label.text = str(current_level_display)
