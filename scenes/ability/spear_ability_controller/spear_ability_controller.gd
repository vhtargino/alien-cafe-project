extends Node

var max_range = 260

@export var spear_ability: PackedScene

@onready var timer: Timer = $Timer

var base_damage = 7
var additional_damage_percent = 1

var speed = 300

var base_wait_time
var upgrade_rate_multiplier = 1.0
var booster_rate_multiplier = 1.0

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
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(max_range, 2)
	)
	
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	var spear_instance = spear_ability.instantiate() as SpearAbility
	foreground.add_child(spear_instance)
	spear_instance.hitbox_component.damage = (
		base_damage *
		additional_damage_percent *
		MaxLevelEvents.damage *
		player.overall_damage_multiplier
		)
	
	spear_instance.global_position = player.global_position
	
	var target_enemy = enemies[0]
	spear_instance.look_at(target_enemy.global_position)
	spear_instance.rotation += PI / 2
	
	var distance = spear_instance.global_position.distance_to(target_enemy.global_position)
	var time = distance / speed
	
	SoundUtils.play_spear_sound()
	
	var tween = spear_instance.create_tween()
	tween.tween_property(spear_instance, "global_position", target_enemy.global_position, time)\
	.set_trans(Tween.TRANS_LINEAR)\
	.set_ease(Tween.EASE_OUT)
	
	await tween.finished
	spear_instance.queue_free()


func on_timer_timeout():
	for i in player.weapon_spawn_amount:
		spawn_weapon()
		await get_tree().create_timer(.033).timeout


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "spear_rate":
		var percent_reduction = current_upgrades["spear_rate"]["quantity"] * .15
		upgrade_rate_multiplier = 1.0 - percent_reduction
		update_timer_wait_time()
	elif upgrade.id == "spear_damage":
		additional_damage_percent = 1 + (current_upgrades["spear_damage"]["quantity"] * .1)


func on_double_shot_booster_applied():
	booster_rate_multiplier = 1.0 / player.attack_speed_multiplier
	update_timer_wait_time()

	await player.double_shot_booster.timer.timeout
	
	booster_rate_multiplier = 1.0
	update_timer_wait_time()


func on_level_up_above_max():
	if MaxLevelEvents.random_attribute == "MAXL_RATE":
		update_timer_wait_time()
