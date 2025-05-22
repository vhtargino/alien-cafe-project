extends Node

@export var force_field_ability: PackedScene

@onready var timer: Timer = $Timer

var base_damage = 4
var base_wait_time
const initial_radius = 25.0

var upgrade_rate_multiplier = 1.0
var booster_rate_multiplier = 1.0

var force_field_instance: Node2D

var enemies_inside_area: Array[CharacterBody2D] = []


func _ready() -> void:
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	BoosterEvents.double_shot_booster_applied.connect(on_double_shot_booster_applied)
	
	instantiate_force_field()
	force_field_instance.hitbox_component.body_entered.connect(on_body_entered)
	force_field_instance.hitbox_component.body_exited.connect(on_body_exited)


func instantiate_force_field():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	force_field_instance = force_field_ability.instantiate() as ForceFieldAbility
	player.add_child(force_field_instance)
	
	force_field_instance.hitbox_component.damage = base_damage


func update_timer_wait_time():
	var final_multiplier = upgrade_rate_multiplier * booster_rate_multiplier
	var final_wait_time = base_wait_time * final_multiplier
	$Timer.wait_time = final_wait_time
	$Timer.start()


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
		hurtbox.on_area_entered(force_field_instance.hitbox_component)


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary): 
	if upgrade.id == "force_field_range":
		var circle_shape = force_field_instance.hitbox_component.get_child(0).shape as CircleShape2D
		circle_shape.radius += 15
		var new_scale = circle_shape.radius / initial_radius
		force_field_instance.sprite.scale = Vector2(new_scale, new_scale)
	elif upgrade.id == "force_field_damage":
		force_field_instance.hitbox_component.damage *= 1.2
	elif upgrade.id == "force_field_rate":
		var percent_reduction = current_upgrades["force_field_rate"]["quantity"] * .15
		upgrade_rate_multiplier = 1.0 - percent_reduction
		update_timer_wait_time()


func on_double_shot_booster_applied():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	booster_rate_multiplier = 1.0 / player.attack_speed_multiplier
	update_timer_wait_time()

	#await get_tree().create_timer(duration).timeout
	await player.double_shot_booster.timer.timeout
	
	booster_rate_multiplier = 1.0
	update_timer_wait_time()
