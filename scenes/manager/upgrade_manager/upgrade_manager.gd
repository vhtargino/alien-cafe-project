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

var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")
var upgrade_player_health = preload("res://resources/upgrades/player_health.tres")
var upgrade_pickup_range = preload("res://resources/upgrades/pickup_range.tres")
var upgrade_player_armor = preload("res://resources/upgrades/player_armor.tres")
var upgrade_player_regeneration = preload("res://resources/upgrades/player_regeneration.tres")

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
	upgrade_pool.add_item(upgrade_anvil, 5)

	upgrade_pool.add_item(upgrade_sword_rate, 10)
	upgrade_pool.add_item(upgrade_sword_damage, 10)
	
	upgrade_pool.add_item(upgrade_player_speed, 7)
	upgrade_pool.add_item(upgrade_player_health, 7)
	upgrade_pool.add_item(upgrade_pickup_range, 7)
	upgrade_pool.add_item(upgrade_player_armor, 3)
	upgrade_pool.add_item(upgrade_player_regeneration, 7)
	
	experience_manager.level_up.connect(on_level_up)
	
	current_upgrades[initial_sword.id] = {"resource": initial_sword, "quantity": 1}
	abilities_current_level[initial_sword.name] = {"image": initial_sword.image, "type": initial_sword.type, "level": 1}
	current_weapons_quantity = 1


func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	
	if upgrade.sub_type == "weapon_main":
		current_weapons_quantity += 1
	
	if upgrade.sub_type == "power_up_upgrade":
		if not has_upgrade:
			current_power_ups_quantity += 1
	
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
		upgrade_pool.add_item(upgrade_axe_damage, 7)
		upgrade_pool.add_item(upgrade_axe_rate, 7)
		upgrade_pool.add_item(upgrade_axe_range, 7)
	elif chosen_upgrade.id == upgrade_spear.id:
		upgrade_pool.add_item(upgrade_spear_damage, 7)
		upgrade_pool.add_item(upgrade_spear_rate, 7)
	elif chosen_upgrade.id == upgrade_force_field.id:
		upgrade_pool.add_item(upgrade_force_field_range, 7)
		upgrade_pool.add_item(upgrade_force_field_damage, 7)
		upgrade_pool.add_item(upgrade_force_field_rate, 7)
	elif chosen_upgrade.id == upgrade_anvil.id:
		upgrade_pool.add_item(upgrade_anvil_damage, 7)
		upgrade_pool.add_item(upgrade_anvil_rate, 5)


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
		
		chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades


func clear_unacquired_weapon_mains_from_pool():
	if current_weapons_quantity >= max_weapons_quantity:
		var items_to_remove = []

		for item in upgrade_pool.items:
			var upgrade: AbilityUpgrade = item["item"]
			
			if upgrade.sub_type == "weapon_main" and not current_upgrades.has(upgrade.id):
				items_to_remove.append(item)

		for item in items_to_remove:
			upgrade_pool.items.erase(item)


func clear_unacquired_power_ups_from_pool():
	if current_power_ups_quantity >= max_power_ups_quantity:
		var items_to_remove = []

		for item in upgrade_pool.items:
			var upgrade: AbilityUpgrade = item["item"]
			
			if upgrade.sub_type == "power_up_upgrade" and not current_upgrades.has(upgrade.id):
				items_to_remove.append(item)

		for item in items_to_remove:
			upgrade_pool.items.erase(item)


func on_level_up(_current_level: int):
	clear_unacquired_weapon_mains_from_pool()
	clear_unacquired_power_ups_from_pool()
	
	var chosen_upgrades = pick_upgrades()
	
	if chosen_upgrades.is_empty():
		return
	
	var upgrade_screen_instance = upgrade_screen_scene.instantiate() as CanvasLayer
	add_child(upgrade_screen_instance)
	
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)

	var first_card = upgrade_screen_instance.card_container.get_child(0)
	if first_card == null:
		return
	
	first_card.grab_focus()


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
	set_ability_level(upgrade)
