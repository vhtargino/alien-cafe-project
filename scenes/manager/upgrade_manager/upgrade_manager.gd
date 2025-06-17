extends Node

signal ability_level_up(current_abilities_level: Dictionary)

@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene


var initial_sword = preload("res://resources/upgrades/sword_main.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")

var upgrade_axe = preload("res://resources/upgrades/axe_main.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_axe_rate = preload("res://resources/upgrades/axe_rate.tres")
var upgrade_axe_range = preload("res://resources/upgrades/axe_range.tres")

var upgrade_spear = preload("res://resources/upgrades/spear_main.tres")
var upgrade_spear_damage = preload("res://resources/upgrades/spear_damage.tres")
var upgrade_spear_rate = preload("res://resources/upgrades/spear_rate.tres")

var upgrade_force_field = preload("res://resources/upgrades/force_field_main.tres")
var upgrade_force_field_range = preload("res://resources/upgrades/force_field_range.tres")
var upgrade_force_field_damage = preload("res://resources/upgrades/force_field_damage.tres")
var upgrade_force_field_rate = preload("res://resources/upgrades/force_field_rate.tres")

var upgrade_anvil = preload("res://resources/upgrades/anvil_main.tres")
var upgrade_anvil_damage = preload("res://resources/upgrades/anvil_damage.tres")
var upgrade_anvil_rate = preload("res://resources/upgrades/anvil_rate.tres")

var upgrade_player_speed_main = preload("res://resources/upgrades/player_speed_main.tres")
var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")

var upgrade_player_health_main = preload("res://resources/upgrades/player_health_main.tres")
var upgrade_player_health = preload("res://resources/upgrades/player_health.tres")

var upgrade_pickup_range_main = preload("res://resources/upgrades/pickup_range_main.tres")
var upgrade_pickup_range = preload("res://resources/upgrades/pickup_range.tres")

var upgrade_player_armor_main = preload("res://resources/upgrades/player_armor_main.tres")
var upgrade_player_armor = preload("res://resources/upgrades/player_armor.tres")

var upgrade_player_regeneration_main = preload("res://resources/upgrades/player_regeneration_main.tres")
var upgrade_player_regeneration = preload("res://resources/upgrades/player_regeneration.tres")

var upgrade_overall_damage_main = preload("res://resources/upgrades/overall_damage_main.tres")
var upgrade_overall_damage = preload("res://resources/upgrades/overall_damage.tres")

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var abilities_current_level = {}

var current_weapons_quantity: int
var max_weapons_quantity: int = 4
var current_power_ups_quantity: int
var max_power_ups_quantity: int = 4


func _ready():
	upgrade_pool.add_item(upgrade_axe, 10)
	upgrade_pool.add_item(upgrade_spear, 10)
	upgrade_pool.add_item(upgrade_force_field, 10)
	upgrade_pool.add_item(upgrade_anvil, 10)

	upgrade_pool.add_item(upgrade_sword_rate, 7)
	upgrade_pool.add_item(upgrade_sword_damage, 6)
	
	upgrade_pool.add_item(upgrade_player_speed_main, 7)
	upgrade_pool.add_item(upgrade_player_health_main, 7)
	upgrade_pool.add_item(upgrade_pickup_range_main, 7)
	upgrade_pool.add_item(upgrade_player_armor_main, 4)
	upgrade_pool.add_item(upgrade_player_regeneration_main, 7)
	upgrade_pool.add_item(upgrade_overall_damage_main, 4)
	
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
		upgrade_pool.add_item(upgrade_axe_rate, 7)
		upgrade_pool.add_item(upgrade_axe_damage, 6)
		upgrade_pool.add_item(upgrade_axe_range, 5)
	elif chosen_upgrade.id == upgrade_spear.id:
		upgrade_pool.add_item(upgrade_spear_rate, 7)
		upgrade_pool.add_item(upgrade_spear_damage, 6)
	elif chosen_upgrade.id == upgrade_force_field.id:
		upgrade_pool.add_item(upgrade_force_field_range, 7)
		upgrade_pool.add_item(upgrade_force_field_damage, 6)
		upgrade_pool.add_item(upgrade_force_field_rate, 7)
	elif chosen_upgrade.id == upgrade_anvil.id:
		upgrade_pool.add_item(upgrade_anvil_damage, 7)
		upgrade_pool.add_item(upgrade_anvil_rate, 6)
	elif chosen_upgrade.id == upgrade_pickup_range_main.id:
		upgrade_pool.add_item(upgrade_pickup_range, 7)
	elif chosen_upgrade.id == upgrade_player_armor_main.id:
		upgrade_pool.add_item(upgrade_player_armor, 7)
	elif chosen_upgrade.id == upgrade_player_health_main.id:
		upgrade_pool.add_item(upgrade_player_health, 7)
	elif chosen_upgrade.id == upgrade_player_regeneration_main.id:
		upgrade_pool.add_item(upgrade_player_regeneration, 7)
	elif chosen_upgrade.id == upgrade_player_speed_main.id:
		upgrade_pool.add_item(upgrade_player_speed, 7)
	elif chosen_upgrade.id == upgrade_overall_damage_main.id:
		upgrade_pool.add_item(upgrade_overall_damage, 7)


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
