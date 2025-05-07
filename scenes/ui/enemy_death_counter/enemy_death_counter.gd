extends CanvasLayer

@onready var label: Label = $MarginContainer/HBoxContainer/Label

var enemies_defeated: int


func _ready() -> void:
	GameEvents.enemy_died.connect(on_enemy_died)
	
	enemies_defeated = 0
	label.text = str(enemies_defeated)


func update_label(total_enemies: int):
	label.text = str(total_enemies)


func on_enemy_died():
	enemies_defeated += 1
	update_label(enemies_defeated)
