extends CanvasLayer

@export var upgrade_manager: Node

@onready var weapons_container = $CenterContainer/HBoxContainer/WeaponsContainer
@onready var powerups_container = $CenterContainer/HBoxContainer/PowerUpsContainer

var displayed_upgrades = []


func _ready():
	upgrade_manager.ability_level_up.connect(on_ability_level_up)
	
	var initial = upgrade_manager.initial_sword
	$CenterContainer/HBoxContainer/WeaponsContainer/Weapon1/TextureRect.texture = initial.image
	displayed_upgrades.append(initial.name)


func on_ability_level_up(abilities_current_level: Dictionary):
	for key in abilities_current_level.keys():
		var ability_data = abilities_current_level[key]
		var ability_type = ability_data["type"]
		var ability_image = ability_data["image"]
		var ability_level = ability_data["level"]

		var container = weapons_container if ability_type == "weapon" else powerups_container

		for item in container.get_children():
			var texture_rect = item.get_child(0)
			var label = texture_rect.get_node("Label")
			
			if texture_rect.texture == ability_image:
				label.text = str(ability_level)
				break
			
			if texture_rect.texture == null:
				texture_rect.texture = ability_image
				label.text = str(ability_level)
				break
