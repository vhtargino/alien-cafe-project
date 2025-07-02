extends Node

signal ability_level_up(current_abilities_level: Dictionary)

@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

@onready var resource_preloader: ResourcePreloader = $ResourcePreloader

var initial_sword: Ability

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var abilities_current_level = {}

var current_weapons_quantity: int
var max_weapons_quantity: int = 4
var current_power_ups_quantity: int
var max_power_ups_quantity: int = 4


func _ready():
	initial_sword = resource_preloader.get_resource("sword_main")
	#upgrade_pool.add_item(resource_preloader.get_resource("sword_damage"), resource_preloader.get_resource("sword_damage").weight)
	#upgrade_pool.add_item(resource_preloader.get_resource("sword_rate"), resource_preloader.get_resource("sword_rate").weight)
	
	for item in resource_preloader.get_resource_list():
		if resource_preloader.get_resource(item).sub_type == "weapon_main"\
		or resource_preloader.get_resource(item).sub_type == "power_up_main"\
		or resource_preloader.get_resource(item).id == "sword_damage"\
		or resource_preloader.get_resource(item).id == "sword_rate":
			if resource_preloader.get_resource(item).id == "sword_main":
				continue
			upgrade_pool.add_item(resource_preloader.get_resource(item), resource_preloader.get_resource(item).weight)
	
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
	if chosen_upgrade.sub_type == "weapon_upgrade" or chosen_upgrade.sub_type == "power_up_upgrade":
		return
	
	for item in resource_preloader.get_resource_list():
		if resource_preloader.get_resource(item).name == chosen_upgrade.name and resource_preloader.get_resource(item).sub_type.right(5) != "_main":
			upgrade_pool.add_item(resource_preloader.get_resource(item), resource_preloader.get_resource(item).weight)


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
