extends Node

var max_range = 150

@export var sword_ability: PackedScene

var base_damage = 5
var additional_damage_percent = 1
var base_wait_time

var upgrade_rate_multiplier = 1.0
var booster_rate_multiplier = 1.0


func _ready() -> void:
	base_wait_time = $Timer.wait_time
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
	
	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = base_damage * additional_damage_percent
	
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "sword_rate":
		var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.1
		upgrade_rate_multiplier = 1.0 - percent_reduction	
		update_timer_wait_time()
	elif upgrade.id == "sword_damage":
		additional_damage_percent = 1 + (current_upgrades["sword_damage"]["quantity"] * .15)


func on_double_shot_booster_applied(duration: float):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	booster_rate_multiplier = 1.0 / player.attack_speed_multiplier
	update_timer_wait_time()

	await get_tree().create_timer(duration).timeout
	
	booster_rate_multiplier = 1.0
	update_timer_wait_time()
