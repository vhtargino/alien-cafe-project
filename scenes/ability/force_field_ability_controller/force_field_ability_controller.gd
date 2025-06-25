extends Node

@export var force_field_ability: PackedScene

@onready var timer: Timer = $Timer

const base_damage = 4
var upgrade_damage_multiplier = 1

const base_radius = 25.0
const base_scale = 1
var upgrade_range_multiplier = 1

var base_wait_time
var upgrade_rate_multiplier = 1.0
var booster_rate_multiplier = 1.0

var force_field_instance: Node2D

var enemies_inside_area: Array[CharacterBody2D] = []

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
	
	instantiate_force_field()
	force_field_instance.hitbox_component.body_entered.connect(on_body_entered)
	force_field_instance.hitbox_component.body_exited.connect(on_body_exited)


func instantiate_force_field():
	force_field_instance = force_field_ability.instantiate() as ForceFieldAbility
	player.add_child(force_field_instance)
	update_damage()


func update_damage():
	var final_damage_multiplier = (
		upgrade_damage_multiplier * 
		MaxLevelEvents.damage * 
		player.overall_damage_multiplier
		)
	var final_damage = base_damage * final_damage_multiplier
	force_field_instance.hitbox_component.damage = final_damage


func update_timer_wait_time():
	var final_multiplier = upgrade_rate_multiplier * booster_rate_multiplier * MaxLevelEvents.attack_rate
	var final_wait_time = base_wait_time * final_multiplier
	timer.wait_time = max(0.1, final_wait_time)


func update_range():
	var final_range_multiplier = upgrade_range_multiplier * MaxLevelEvents.attack_range
	var final_radius = base_radius * final_range_multiplier
	var final_scale = base_scale * final_range_multiplier
	force_field_instance.hitbox_component.get_child(0).shape.radius = final_radius
	force_field_instance.sprite.scale = Vector2(final_scale, final_scale)


func on_body_entered(other_body: CharacterBody2D):
	enemies_inside_area.append(other_body)


func on_body_exited(other_body: CharacterBody2D):
	enemies_inside_area.erase(other_body)


func on_timer_timeout():
	if enemies_inside_area.size() == 0 or enemies_inside_area == null:
		return
	
	for enemy in enemies_inside_area:
		if not enemy.has_node("HurtboxComponent"):
			return
		
		var hurtbox = enemy.get_node("HurtboxComponent")
		for i in player.weapon_spawn_amount:
			if hurtbox == null:
				return
			
			hurtbox.on_area_entered(force_field_instance.hitbox_component)
			await get_tree().create_timer(.033).timeout


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary): 
	if upgrade.id == "force_field_range":
		upgrade_range_multiplier += .4
		update_range()
	elif upgrade.id == "force_field_damage":
		upgrade_damage_multiplier += .2
		update_damage()
	elif upgrade.id == "force_field_rate":
		var percent_reduction = current_upgrades["force_field_rate"]["quantity"] * .15
		upgrade_rate_multiplier = 1.0 - percent_reduction
		update_timer_wait_time()
	elif upgrade.id == "overall_damage_main" or upgrade.id == "overall_damage":
		update_damage()
	elif upgrade.id == "critical_main" or upgrade.id == "critical":
		update_damage()


func on_double_shot_booster_applied():
	booster_rate_multiplier = 1.0 / player.attack_speed_multiplier
	update_timer_wait_time()

	await player.double_shot_booster.timer.timeout
	
	booster_rate_multiplier = 1.0
	update_timer_wait_time()


func on_level_up_above_max():
	if MaxLevelEvents.random_attribute == "MAXL_DMG":
		update_damage()
	elif MaxLevelEvents.random_attribute == "MAXL_RATE":
		update_timer_wait_time()
	elif MaxLevelEvents.random_attribute == "MAXL_RANGE":
		update_range()
