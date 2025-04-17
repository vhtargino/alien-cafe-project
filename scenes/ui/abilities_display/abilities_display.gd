extends CanvasLayer

@export var upgrade_manager: Node

var displayed_upgrades = []


func _ready():
	upgrade_manager.ability_level_up.connect(on_ability_level_up)
	
	var initial = upgrade_manager.initial_sword
	$CenterContainer/HBoxContainer/WeaponsContainer/Weapon1/TextureRect.texture = initial.image
	displayed_upgrades.append(initial.name)


func on_ability_level_up(abilities_current_level: Dictionary):
	var weapons_container = $CenterContainer/HBoxContainer/WeaponsContainer
	var powerups_container = $CenterContainer/HBoxContainer/PowerUpsContainer

	for key in abilities_current_level.keys():
		var upgrade_data = abilities_current_level[key]
		var upgrade_type = upgrade_data["type"]
		var upgrade_image = upgrade_data["image"]
		var upgrade_level = upgrade_data["level"]

		var container = weapons_container if upgrade_type == "weapon" else powerups_container

		for item in container.get_children():
			var texture_rect = item.get_child(0)
			var label = texture_rect.get_node("Label")
			
			if texture_rect.texture == upgrade_image:
				label.text = str(upgrade_level)
				break
			
			if texture_rect.texture == null:
				texture_rect.texture = upgrade_image
				label.text = str(upgrade_level)
				break


func _update_icons_for_type(abilities_dict: Dictionary, upgrade_type: String, container: Node):
	for key in abilities_dict.keys():
		var upgrade_info = abilities_dict[key]
		
		if upgrade_info["type"] != upgrade_type:
			continue
		
		if displayed_upgrades.has(key):
			continue
		
		for slot in container.get_children():
			var texture_rect := slot.get_child(0)
			if texture_rect.texture == null:
				texture_rect.texture = upgrade_info["image"]
				displayed_upgrades.append(key)
				break
