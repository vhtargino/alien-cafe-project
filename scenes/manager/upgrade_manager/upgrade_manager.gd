extends Node

signal ability_level_up(current_abilities_level: Dictionary)

@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var initial_sword = preload("res://resources/upgrades/weapons_upgrades/sword_upgrade/sword_main.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/weapons_upgrades/sword_upgrade/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/weapons_upgrades/sword_upgrade/sword_damage.tres")

var upgrade_axe = preload("res://resources/upgrades/weapons_upgrades/axe_upgrade/axe_main.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/weapons_upgrades/axe_upgrade/axe_damage.tres")
var upgrade_axe_rate = preload("res://resources/upgrades/weapons_upgrades/axe_upgrade/axe_rate.tres")
var upgrade_axe_range = preload("res://resources/upgrades/weapons_upgrades/axe_upgrade/axe_range.tres")

var upgrade_spear = preload("res://resources/upgrades/weapons_upgrades/spear_upgrade/spear_main.tres")
var upgrade_spear_damage = preload("res://resources/upgrades/weapons_upgrades/spear_upgrade/spear_damage.tres")
var upgrade_spear_rate = preload("res://resources/upgrades/weapons_upgrades/spear_upgrade/spear_rate.tres")

var upgrade_force_field = preload("res://resources/upgrades/weapons_upgrades/force_field_upgrade/force_field_main.tres")
var upgrade_force_field_range = preload("res://resources/upgrades/weapons_upgrades/force_field_upgrade/force_field_range.tres")
var upgrade_force_field_damage = preload("res://resources/upgrades/weapons_upgrades/force_field_upgrade/force_field_damage.tres")
var upgrade_force_field_rate = preload("res://resources/upgrades/weapons_upgrades/force_field_upgrade/force_field_rate.tres")

var upgrade_anvil = preload("res://resources/upgrades/weapons_upgrades/anvil_upgrade/anvil_main.tres")
var upgrade_anvil_damage = preload("res://resources/upgrades/weapons_upgrades/anvil_upgrade/anvil_damage.tres")
var upgrade_anvil_rate = preload("res://resources/upgrades/weapons_upgrades/anvil_upgrade/anvil_rate.tres")

var upgrade_caramel_bomb = preload("res://resources/upgrades/weapons_upgrades/caramel_bomb_upgrade/caramel_main.tres")
var upgrade_caramel_damage = preload("res://resources/upgrades/weapons_upgrades/caramel_bomb_upgrade/caramel_damage.tres")
var upgrade_caramel_rate = preload("res://resources/upgrades/weapons_upgrades/caramel_bomb_upgrade/caramel_rate.tres")

var upgrade_orient = preload("res://resources/upgrades/weapons_upgrades/orient_espresso_upgrade/orient_main.tres")
var upgrade_orient_damage = preload("res://resources/upgrades/weapons_upgrades/orient_espresso_upgrade/orient_damage.tres")
var upgrade_orient_rate = preload("res://resources/upgrades/weapons_upgrades/orient_espresso_upgrade/orient_rate.tres")
var upgrade_orient_speed = preload("res://resources/upgrades/weapons_upgrades/orient_espresso_upgrade/orient_speed.tres")

var upgrade_coffee_cup_spinner = preload("res://resources/upgrades/weapons_upgrades/coffee_cup_spinner_upgrade/coffee_cup_spinner_main.tres")
var upgrade_cup_damage = preload("res://resources/upgrades/weapons_upgrades/coffee_cup_spinner_upgrade/coffee_cup_damage.tres")
var upgrade_cup_rate = preload("res://resources/upgrades/weapons_upgrades/coffee_cup_spinner_upgrade/coffee_cup_rate.tres")
var upgrade_cup_radius = preload("res://resources/upgrades/weapons_upgrades/coffee_cup_spinner_upgrade/coffee_cup_radius.tres")
var upgrade_cup_duration = preload("res://resources/upgrades/weapons_upgrades/coffee_cup_spinner_upgrade/coffee_cup_duration.tres")

var upgrade_player_speed_main = preload("res://resources/upgrades/power_ups_upgrades/player_speed_upgrade/player_speed_main.tres")
var upgrade_player_speed = preload("res://resources/upgrades/power_ups_upgrades/player_speed_upgrade/player_speed.tres")

var upgrade_player_health_main = preload("res://resources/upgrades/power_ups_upgrades/player_health_upgrade/player_health_main.tres")
var upgrade_player_health = preload("res://resources/upgrades/power_ups_upgrades/player_health_upgrade/player_health.tres")

var upgrade_pickup_range_main = preload("res://resources/upgrades/power_ups_upgrades/pickup_range_upgrade/pickup_range_main.tres")
var upgrade_pickup_range = preload("res://resources/upgrades/power_ups_upgrades/pickup_range_upgrade/pickup_range.tres")

var upgrade_player_armor_main = preload("res://resources/upgrades/power_ups_upgrades/player_armor_upgrade/player_armor_main.tres")
var upgrade_player_armor = preload("res://resources/upgrades/power_ups_upgrades/player_armor_upgrade/player_armor.tres")

var upgrade_player_regeneration_main = preload("res://resources/upgrades/power_ups_upgrades/player_regeneration_upgrade/player_regeneration_main.tres")
var upgrade_player_regeneration = preload("res://resources/upgrades/power_ups_upgrades/player_regeneration_upgrade/player_regeneration.tres")

var upgrade_overall_damage_main = preload("res://resources/upgrades/power_ups_upgrades/overall_damage_upgrade/overall_damage_main.tres")
var upgrade_overall_damage = preload("res://resources/upgrades/power_ups_upgrades/overall_damage_upgrade/overall_damage.tres")

var cloner_main = preload("res://resources/upgrades/power_ups_upgrades/cloner_upgrade/cloner_main.tres")
var cloner = preload("res://resources/upgrades/power_ups_upgrades/cloner_upgrade/cloner.tres")

var critical = preload("res://resources/upgrades/power_ups_upgrades/critical_upgrade/critical.tres")
var critical_main = preload("res://resources/upgrades/power_ups_upgrades/critical_upgrade/critical_main.tres")

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var abilities_current_level = {}

var current_weapons_quantity: int
var max_weapons_quantity: int = 4
var current_power_ups_quantity: int
var max_power_ups_quantity: int = 4


func _ready():
	upgrade_pool.add_item(upgrade_axe, 15)
	upgrade_pool.add_item(upgrade_spear, 15)
	upgrade_pool.add_item(upgrade_force_field, 15)
	upgrade_pool.add_item(upgrade_anvil, 15)
	upgrade_pool.add_item(upgrade_caramel_bomb, 10)
	upgrade_pool.add_item(upgrade_orient, 15)
	upgrade_pool.add_item(upgrade_coffee_cup_spinner, 15)

	upgrade_pool.add_item(upgrade_sword_rate, 12)
	upgrade_pool.add_item(upgrade_sword_damage, 11)
	
	upgrade_pool.add_item(upgrade_player_speed_main, 12)
	upgrade_pool.add_item(upgrade_player_health_main, 12)
	upgrade_pool.add_item(upgrade_pickup_range_main, 12)
	upgrade_pool.add_item(upgrade_player_armor_main, 12)
	upgrade_pool.add_item(upgrade_player_regeneration_main, 12)
	upgrade_pool.add_item(upgrade_overall_damage_main, 9)
	upgrade_pool.add_item(cloner_main, 1)
	upgrade_pool.add_item(critical_main, 12)
	
	experience_manager.level_up.connect(on_level_up)
	
	current_upgrades[initial_sword.id] = {"resource": initial_sword, "quantity": 1}
	abilities_current_level[initial_sword.name] = {"image": initial_sword.image, "type": initial_sword.type, "level": 1}
	current_weapons_quantity = 1


func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	
	if upgrade.sub_type == "weapon_main":
		current_weapons_quantity += 1
		if current_weapons_quantity == max_weapons_quantity:
			clear_unacquired_weapon_mains_from_pool()
	
	if upgrade.sub_type == "power_up_main":
		current_power_ups_quantity += 1
		if current_power_ups_quantity == max_power_ups_quantity:
			clear_unacquired_power_ups_from_pool()
	
	if not has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1

	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == upgrade_axe.id:
		upgrade_pool.add_item(upgrade_axe_rate, 12)
		upgrade_pool.add_item(upgrade_axe_damage, 11)
		upgrade_pool.add_item(upgrade_axe_range, 10)
	elif chosen_upgrade.id == upgrade_spear.id:
		upgrade_pool.add_item(upgrade_spear_rate, 12)
		upgrade_pool.add_item(upgrade_spear_damage, 11)
	elif chosen_upgrade.id == upgrade_force_field.id:
		upgrade_pool.add_item(upgrade_force_field_range, 12)
		upgrade_pool.add_item(upgrade_force_field_damage, 11)
		upgrade_pool.add_item(upgrade_force_field_rate, 12)
	elif chosen_upgrade.id == upgrade_anvil.id:
		upgrade_pool.add_item(upgrade_anvil_damage, 12)
		upgrade_pool.add_item(upgrade_anvil_rate, 11)
	elif chosen_upgrade.id == upgrade_caramel_bomb.id:
		upgrade_pool.add_item(upgrade_caramel_damage, 12)
		upgrade_pool.add_item(upgrade_caramel_rate, 11)
	elif chosen_upgrade.id == upgrade_orient.id:
		upgrade_pool.add_item(upgrade_orient_speed, 13)
		upgrade_pool.add_item(upgrade_orient_rate, 12)
		upgrade_pool.add_item(upgrade_orient_damage, 11)
	elif chosen_upgrade.id == upgrade_coffee_cup_spinner.id:
		upgrade_pool.add_item(upgrade_cup_damage, 12)
		upgrade_pool.add_item(upgrade_cup_radius, 10)
		upgrade_pool.add_item(upgrade_cup_rate, 14)
		upgrade_pool.add_item(upgrade_cup_duration, 13)
	elif chosen_upgrade.id == upgrade_pickup_range_main.id:
		upgrade_pool.add_item(upgrade_pickup_range, 12)
	elif chosen_upgrade.id == upgrade_player_armor_main.id:
		upgrade_pool.add_item(upgrade_player_armor, 12)
	elif chosen_upgrade.id == upgrade_player_health_main.id:
		upgrade_pool.add_item(upgrade_player_health, 12)
	elif chosen_upgrade.id == upgrade_player_regeneration_main.id:
		upgrade_pool.add_item(upgrade_player_regeneration, 12)
	elif chosen_upgrade.id == upgrade_player_speed_main.id:
		upgrade_pool.add_item(upgrade_player_speed, 12)
	elif chosen_upgrade.id == upgrade_overall_damage_main.id:
		upgrade_pool.add_item(upgrade_overall_damage, 12)
	elif chosen_upgrade.id == cloner_main.id:
		upgrade_pool.add_item(cloner, 1)
	elif chosen_upgrade.id == critical_main.id:
		upgrade_pool.add_item(critical, 12)


func set_ability_level(upgrade: AbilityUpgrade):
	var has_upgrade = abilities_current_level.has(upgrade.name)
	if not has_upgrade:
		abilities_current_level[upgrade.name] = {
			"image": upgrade.image,
			"type": upgrade.type,
			"level": 1
		}
	else:
		abilities_current_level[upgrade.name]["level"] += 1
	
	ability_level_up.emit(abilities_current_level)


func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in 3:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		
		if chosen_upgrade != null:
			chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades


func clear_unacquired_weapon_mains_from_pool():
	if current_weapons_quantity >= max_weapons_quantity:
		for item in upgrade_pool.items:
			if item["item"].sub_type == "weapon_main":
				upgrade_pool.remove_item(item["item"] as AbilityUpgrade)


func clear_unacquired_power_ups_from_pool():
	if current_power_ups_quantity >= max_power_ups_quantity:
		for item in upgrade_pool.items:
			if item["item"].sub_type == "power_up_main":
				upgrade_pool.remove_item(item["item"] as AbilityUpgrade)


func on_level_up(_current_level: int):
	var chosen_upgrades = pick_upgrades()
	
	if chosen_upgrades.is_empty():
		MaxLevelEvents.increase_random_attribute()
		MaxLevelEvents.emit_level_up_above_max()
		return
	
	var ui_layer = get_tree().get_first_node_in_group("ui_layer")
	if ui_layer == null:
		return
	
	var upgrade_screen_instance = upgrade_screen_scene.instantiate() as CanvasLayer
	ui_layer.add_child(upgrade_screen_instance)

	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)

	# Apenas para pegar o foco do primeiro card
	var first_card = upgrade_screen_instance.card_container.get_child(0)
	if first_card == null:
		return
	
	SoundUtils.disable_focus_sound()
	first_card.grab_focus()
	SoundUtils.enable_focus_sound()


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
	set_ability_level(upgrade)
