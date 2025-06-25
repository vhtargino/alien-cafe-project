extends Node

@export var caramel_bomb_scene: PackedScene

@onready var timer: Timer = $Timer

var max_range: float = 110

var base_damage: float = 15
var additional_damage_percent: float = 1.0

var base_wait_time: float
var upgrade_rate_multiplier: float = 1.0
var booster_rate_multiplier: float = 1.0

var direction: Vector2

var player: Node2D
var foreground: Node2D
var ground: Node2D


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	foreground = get_tree().get_first_node_in_group("foreground_layer")
	if foreground == null:
		return
	
	ground = get_tree().get_first_node_in_group("ground_layer")
	if ground == null:
		return
	
	direction = Vector2(0, -max_range)
	
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	BoosterEvents.double_shot_booster_applied.connect(on_double_shot_booster_applied)
	MaxLevelEvents.level_up_above_max.connect(on_level_up_above_max)


func update_timer_wait_time():
	var final_multiplier = upgrade_rate_multiplier * booster_rate_multiplier * MaxLevelEvents.attack_rate
	var final_wait_time = base_wait_time * final_multiplier
	timer.wait_time = max(0.1, final_wait_time)


func spawn_weapon():
	var caramel_bomb_instance = caramel_bomb_scene.instantiate() as Node2D
	foreground.add_child(caramel_bomb_instance)
	caramel_bomb_instance.global_position = player.global_position

	var duration: float = 1.0
	var amplitude: float = 20.0
	var start_pos = caramel_bomb_instance.global_position
	var end_pos = start_pos + direction
	
	var tween = create_tween().set_parallel(true)

	tween.tween_method(
		Callable(self, "_move_in_arc").bind(caramel_bomb_instance, start_pos, end_pos, amplitude),
		0.0, 1.0, duration
	).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(caramel_bomb_instance, "scale", Vector2(1.66, 1.66), 0.4)
	tween.chain().tween_property(caramel_bomb_instance, "scale", Vector2(1, 1), 0.4)

	rotate_angle()
	
	tween.finished.connect(on_bomb_tween_finished.bind(caramel_bomb_instance))


func on_bomb_tween_finished(caramel_bomb_instance: Node2D) -> void:
	caramel_bomb_instance.change_sprite()
	foreground.remove_child(caramel_bomb_instance)
	ground.add_child(caramel_bomb_instance)
	
	caramel_bomb_instance.hitbox_component.damage = (
		base_damage *
		additional_damage_percent *
		MaxLevelEvents.damage *
		player.overall_damage_multiplier
	)


func _move_in_arc(progress: float, instance: Node2D, start: Vector2, end: Vector2, amplitude: float) -> void:
	var pos: Vector2 = start.lerp(end, progress)
	pos.y -= sin(progress * PI) * amplitude
	instance.global_position = pos


func rotate_angle():
	direction = direction.rotated(deg_to_rad(45))


func on_timer_timeout():
	for i in player.weapon_spawn_amount:
		spawn_weapon()
		await get_tree().create_timer(.033).timeout


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "caramel_rate":
		var percent_reduction = current_upgrades["caramel_rate"]["quantity"] * .2
		upgrade_rate_multiplier = 1.0 - percent_reduction
		update_timer_wait_time()
	elif upgrade.id == "caramel_damage":
		additional_damage_percent = 1 + (current_upgrades["caramel_damage"]["quantity"] * .15)


func on_double_shot_booster_applied():
	booster_rate_multiplier = 1.0 / player.attack_speed_multiplier
	update_timer_wait_time()

	await player.double_shot_booster.timer.timeout
	
	booster_rate_multiplier = 1.0
	update_timer_wait_time()


func on_level_up_above_max():
	if MaxLevelEvents.random_attribute == "MAXL_RATE":
		update_timer_wait_time()
