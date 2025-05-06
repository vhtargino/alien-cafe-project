extends CanvasLayer

@export var upgrade_manager: Node

@onready var weapons_container = $CenterContainer/HBoxContainer/WeaponsContainer
@onready var powerups_container = $CenterContainer/HBoxContainer/PowerUpsContainer

var displayed_upgrades = []


func _ready():
	upgrade_manager.ability_level_up.connect(on_ability_level_up)
	BoosterEvents.double_shot_booster_applied.connect(on_double_shoot_booster_applied)
	BoosterEvents.waker_booster_applied.connect(on_waker_booster_applied)
	BoosterEvents.iced_coffee_booster_applied.connect(on_iced_coffee_booster_applied)
	BoosterEvents.turbo_expresso_booster_applied.connect(on_turbo_expresso_booster_applied)
	
	BoosterEvents.double_shot_booster_ended.connect(on_double_shoot_booster_ended)
	BoosterEvents.waker_booster_ended.connect(on_waker_booster_ended)
	BoosterEvents.iced_coffee_booster_ended.connect(on_iced_coffee_booster_ended)
	BoosterEvents.turbo_expresso_booster_ended.connect(on_turbo_expresso_booster_ended)
	
	%B1Label.text = str(BoosterEvents.double_shot)
	%B2Label.text = str(BoosterEvents.waker)
	%B3Label.text = str(BoosterEvents.iced_coffee)
	%B4Label.text = str(BoosterEvents.turbo_expresso)

	var initial = upgrade_manager.initial_sword
	$CenterContainer/HBoxContainer/WeaponsContainer/Weapon1/W1Texture.texture = initial.image
	displayed_upgrades.append(initial.name)


func on_ability_level_up(abilities_current_level: Dictionary):
	for key in abilities_current_level.keys():
		var ability_data = abilities_current_level[key]
		var ability_type = ability_data["type"]
		var ability_image = ability_data["image"]
		var ability_level = ability_data["level"]

		var container = weapons_container if ability_type == "weapon" else powerups_container
		
		var letter = "W" if ability_type == "weapon" else "PU"
		var counter = 1
		
		for item in container.get_children():
			var texture_rect = item.get_child(0)
			var label = texture_rect.get_node(letter + str(counter) + "Label")
			counter += 1
			
			if texture_rect.texture == ability_image:
				label.text = str(ability_level)
				break
			
			if texture_rect.texture == null:
				texture_rect.texture = ability_image
				label.text = str(ability_level)
				break


func on_double_shoot_booster_applied():
	%B1Label.text = str(BoosterEvents.double_shot)
	%Booster1.self_modulate = Color(0.8, 0.8, 0.8, 1)


func on_waker_booster_applied():
	%B2Label.text = str(BoosterEvents.waker)
	%Booster2.self_modulate = Color(0.8, 0.8, 0.8, 1)


func on_iced_coffee_booster_applied():
	%B3Label.text = str(BoosterEvents.iced_coffee)
	%Booster3.self_modulate = Color(0.8, 0.8, 0.8, 1)


func on_turbo_expresso_booster_applied():
	%B4Label.text = str(BoosterEvents.turbo_expresso)
	%Booster4.self_modulate = Color(0.8, 0.8, 0.8, 1)


func on_double_shoot_booster_ended():
	%Booster1.self_modulate = Color(1, 1, 1, 1)


func on_waker_booster_ended():
	%Booster2.self_modulate = Color(1, 1, 1, 1)
	

func on_iced_coffee_booster_ended():
	%Booster3.self_modulate = Color(1, 1, 1, 1)
	

func on_turbo_expresso_booster_ended():
	%Booster4.self_modulate = Color(1, 1, 1, 1)
