extends Node

@export var coffee_cup_spinner_scene: PackedScene

@onready var timer: Timer = $Timer

var base_damage: float = 5.0
var upgrade_damage_multiplier: float = 1.0

var base_wait_time: float
var upgrade_rate_multiplier: float = 1.0
var booster_rate_multiplier: float = 1.0

var base_radius: float = 32.0
var upgrade_radius_multiplier: float = 1.0
var current_radius: float

var base_orbit_speed: float = 200.0
var upgrade_speed_multiplier: float = 1.0
var current_speed: float

var base_revolutions: float = 2
var upgrade_revolutions_multiplier: float = 1.0
var current_revolutions: float

var player: Node2D


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	BoosterEvents.double_shot_booster_applied.connect(on_double_shot_booster_applied)
	MaxLevelEvents.level_up_above_max.connect(on_level_up_above_max)
	
	update_revolutions()
	update_radius()
	update_speed()


func update_revolutions():
	current_revolutions = base_revolutions * upgrade_revolutions_multiplier


func update_radius():
	var final_multiplier = upgrade_radius_multiplier * MaxLevelEvents.attack_range
	var final_radius = base_radius * final_multiplier
	current_radius = final_radius


func update_speed():
	var final_multiplier = upgrade_speed_multiplier * MaxLevelEvents.attack_range
	var final_speed = base_orbit_speed * final_multiplier
	current_speed = final_speed


func update_timer_wait_time():
	var final_multiplier = upgrade_rate_multiplier * booster_rate_multiplier * MaxLevelEvents.attack_rate
	var final_wait_time = base_wait_time * final_multiplier
	timer.wait_time = max(0.1, final_wait_time)


func spawn_weapon():
	var coffee_cup_spinner_instance = coffee_cup_spinner_scene.instantiate() as CoffeeCupSpinnerAbility
	player.add_child(coffee_cup_spinner_instance)
	coffee_cup_spinner_instance.global_position = player.global_position
	
	coffee_cup_spinner_instance.hitbox_component.damage = (
		base_damage *
		upgrade_damage_multiplier *
		MaxLevelEvents.damage *
		player.overall_damage_multiplier
	)
	
	var start_angle = 0.0
	var end_angle = TAU * current_revolutions
	var path_length = TAU * current_radius * current_revolutions
	var duration = path_length / current_speed

	var tween = create_tween()

	tween.tween_method(
		func(angle):
			coffee_cup_spinner_instance.position = Vector2(cos(angle), sin(angle)) * current_radius,
		start_angle,
		end_angle,
		duration
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	tween.finished.connect(on_tween_finished.bind(coffee_cup_spinner_instance))


func on_tween_finished(coffee_cup_spinner_instance: CoffeeCupSpinnerAbility):
	coffee_cup_spinner_instance.queue_free()


func on_timer_timeout():
	for i in player.weapon_spawn_amount:
		spawn_weapon()
		await get_tree().create_timer(.033).timeout


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "cup_damage":
		upgrade_damage_multiplier += .2
	elif upgrade.id == "cup_rate":
		upgrade_rate_multiplier -= .15
		update_timer_wait_time()
	elif upgrade.id == "cup_duration":
		upgrade_revolutions_multiplier += .15
		update_revolutions()
	elif upgrade.id == "cup_radius":
		upgrade_radius_multiplier += .5
		upgrade_speed_multiplier += .5
		update_radius()
		update_speed()


func on_level_up_above_max():
	if MaxLevelEvents.random_attribute == "MAXL_RATE":
		update_timer_wait_time()
	elif MaxLevelEvents.random_attribute == "MAXL_RANGE":
		update_radius()
		update_speed()


func on_double_shot_booster_applied():
	booster_rate_multiplier = 1.0 / player.attack_speed_multiplier
	update_timer_wait_time()

	await player.double_shot_booster.timer.timeout
	
	booster_rate_multiplier = 1.0
	update_timer_wait_time()
