extends Node

@export var orient_espresso_scene: PackedScene

@onready var timer: Timer = $Timer

var base_damage: float = 10
var upgrade_damage_multiplier: float = 1.0

var base_wait_time: float
var upgrade_rate_multiplier: float = 1.0
var booster_rate_multiplier: float = 1.0

var base_speed: float = 2
var upgrade_speed_multiplier: float = 1.0
var current_speed: float

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
	MaxLevelEvents.level_up_above_max.connect(on_level_up_above_max)
	BoosterEvents.double_shot_booster_applied.connect(on_double_shot_booster_applied)
	
	update_speed()


func update_speed():
	current_speed = base_speed * upgrade_speed_multiplier


func update_timer_wait_time():
	var final_multiplier = upgrade_rate_multiplier * booster_rate_multiplier * MaxLevelEvents.attack_rate
	var final_wait_time = base_wait_time * final_multiplier
	timer.wait_time = max(0.1, final_wait_time)


func spawn_weapon():
	var orient_espresso_instance = orient_espresso_scene.instantiate() as OrientEspressoAbility
	foreground.add_child(orient_espresso_instance)
	
	var random_y = randf_range(-90, 90)
	var start_position = player.global_position + Vector2(340, random_y)
	var end_position = start_position + Vector2(-880, 0)
	orient_espresso_instance.global_position = start_position
	
	orient_espresso_instance.hitbox_component.damage = (
		base_damage *
		upgrade_damage_multiplier *
		MaxLevelEvents.damage *
		player.overall_damage_multiplier *
		player.apply_critical_multiplier()
	)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(orient_espresso_instance, "global_position", end_position, current_speed)
	tween.chain().tween_property(orient_espresso_instance, "scale", Vector2(0, 0), .1)
	
	tween.finished.connect(on_tween_finished.bind(orient_espresso_instance))


func on_tween_finished(orient_espresso_instance: OrientEspressoAbility):
	orient_espresso_instance.queue_free()


func on_timer_timeout():
	for i in player.weapon_spawn_amount:
		spawn_weapon()
		await get_tree().create_timer(.033).timeout


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "orient_damage":
		upgrade_damage_multiplier += .3
	elif upgrade.id == "orient_rate":
		upgrade_rate_multiplier += .2
		update_timer_wait_time()
	elif upgrade.id == "orient_speed":
		upgrade_speed_multiplier -= .15
		update_speed()


func on_level_up_above_max():
	if MaxLevelEvents.random_attribute == "attack rate":
		update_timer_wait_time()


func on_double_shot_booster_applied():
	booster_rate_multiplier = 1.0 / player.attack_speed_multiplier
	update_timer_wait_time()

	await player.double_shot_booster.timer.timeout
	
	booster_rate_multiplier = 1.0
	update_timer_wait_time()
