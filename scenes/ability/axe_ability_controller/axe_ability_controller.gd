extends Node

@export var axe_ability_scene: PackedScene

@onready var timer: Timer = $Timer

var base_damage = 10
var additional_damage_percent = 1

var base_wait_time

var base_tween_to = 2.0
var base_tween_duration = 3.0
var additional_range_percent = 1

var upgrade_rate_multiplier = 1.0
var booster_rate_multiplier = 1.0


func _ready():
	base_wait_time = timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	BoosterEvents.double_shot_booster_applied.connect(on_double_shot_booster_applied)


func update_timer_wait_time():
	var final_multiplier = upgrade_rate_multiplier * booster_rate_multiplier
	var final_wait_time = base_wait_time * final_multiplier
	$Timer.wait_time = final_wait_time
	$Timer.start()


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground_layer == null:
		return
	
	var axe_instance = axe_ability_scene.instantiate() as Node2D
	axe_instance.tween_to = base_tween_to * additional_range_percent
	axe_instance.tween_duration = base_tween_duration * additional_range_percent
	foreground_layer.add_child(axe_instance)
	#axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = base_damage * additional_damage_percent


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "axe_damage":
		additional_damage_percent = 1 + (current_upgrades["axe_damage"]["quantity"] * .1)
	elif upgrade.id == "axe_rate":
		var percent_reduction = current_upgrades["axe_rate"]["quantity"] * .15
		upgrade_rate_multiplier = 1.0 - percent_reduction
		update_timer_wait_time()
	elif upgrade.id == "axe_range":
		additional_range_percent = 1 + (current_upgrades["axe_range"]["quantity"] * .1)


func on_double_shot_booster_applied(duration: float):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	booster_rate_multiplier = 1.0 / player.attack_speed_multiplier
	update_timer_wait_time()

	await get_tree().create_timer(duration).timeout
	
	booster_rate_multiplier = 1.0
	update_timer_wait_time()
