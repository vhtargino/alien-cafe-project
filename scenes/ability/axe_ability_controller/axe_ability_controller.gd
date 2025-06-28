extends Node

@export var axe_ability_scene: PackedScene

@onready var timer: Timer = $Timer

var base_damage = 10
var additional_damage_percent: float = 1

var base_wait_time

var base_tween_to: float = 2.0
var base_tween_duration: float = 3.0
var additional_range_percent: float = 1

var upgrade_rate_multiplier: float = 1.0
var booster_rate_multiplier: float = 1.0

var player: Node2D
var foreground: Node2D


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	foreground = get_tree().get_first_node_in_group("foreground_layer")
	if foreground == null:
		return
	
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	BoosterEvents.double_shot_booster_applied.connect(on_double_shot_booster_applied)
	MaxLevelEvents.level_up_above_max.connect(on_level_up_above_max)


func update_timer_wait_time():
	var final_multiplier = upgrade_rate_multiplier * booster_rate_multiplier * MaxLevelEvents.attack_rate
	var final_wait_time = base_wait_time * final_multiplier
	timer.wait_time = max(0.1, final_wait_time)
	#timer.start()


func spawn_weapon():
	var axe_instance = axe_ability_scene.instantiate() as Node2D
	axe_instance.tween_to = base_tween_to * additional_range_percent * MaxLevelEvents.attack_range
	axe_instance.tween_duration = base_tween_duration * additional_range_percent * MaxLevelEvents.attack_range
	foreground.add_child(axe_instance)
	#axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = (
		base_damage * 
		additional_damage_percent * 
		MaxLevelEvents.damage * 
		player.overall_damage_multiplier
		)
	SoundUtils.play_axe_sound()


func on_timer_timeout():
	for i in player.weapon_spawn_amount:
		spawn_weapon()
		await get_tree().create_timer(.033).timeout


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "axe_damage":
		additional_damage_percent = 1 + (current_upgrades["axe_damage"]["quantity"] * .1)
	elif upgrade.id == "axe_rate":
		var percent_reduction = current_upgrades["axe_rate"]["quantity"] * .15
		upgrade_rate_multiplier = 1.0 - percent_reduction
		update_timer_wait_time()
	elif upgrade.id == "axe_range":
		additional_range_percent = 1 + (current_upgrades["axe_range"]["quantity"] * .1)


func on_double_shot_booster_applied():
	booster_rate_multiplier = 1.0 / player.attack_speed_multiplier
	update_timer_wait_time()

	await player.double_shot_booster.timer.timeout
	
	booster_rate_multiplier = 1.0
	update_timer_wait_time()


func on_level_up_above_max():
	if MaxLevelEvents.random_attribute == "MAXL_RATE":
		update_timer_wait_time()
