extends CharacterBody2D

@onready var sprite = %PlayerSprite
@onready var healing_sprite: AnimatedSprite2D = $Visuals/HealingSprite
@onready var health_component = $HealthComponent
@onready var health_regen_timer: Timer = $HealthRegenTimer
@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var visuals: Node2D = $Visuals
@onready var velocity_component: Node = $VelocityComponent
@onready var pickup_area_collision: CollisionShape2D = $PickupArea2D/CollisionShape2D

@onready var double_shot_booster: Node = $Boosters/DoubleShotBooster
@onready var waker_booster: Node = $Boosters/WakerBooster
@onready var iced_coffee_booster: Node = $Boosters/IcedCoffeeBooster
@onready var turbo_expresso_booster: Node = $Boosters/TurboExpressoBooster

var number_colliding_bodies = 0
var colliding_bodies: Array = []

var base_max_health: float
var upgrade_health_multiplier: float = 1.0

var base_health_regen: float = 0
var upgrade_health_regen_multiplier: float = 1.0
var current_health_regen: float

var base_armor: float = 0
var upgrade_armor_multiplier: float = 1.0
var current_armor: float

var base_pickup_radius: float
var upgrade_pickup_multiplier: float = 1.0

var base_speed: float
var upgrade_speed_multiplier: float = 1.0
var booster_speed_multiplier: float = 1.0

var attack_speed_multiplier: float = 1.0

var overall_damage_multiplier: float = 1.0

var weapon_spawn_amount: int = 1

var critical_damage_multiplier: float = 1.5
var critical_chance: int = 0


func _ready():
	base_max_health = health_component.max_health
	base_pickup_radius = pickup_area_collision.shape.radius
	base_speed = velocity_component.max_speed
	
	healing_sprite.visible = false
	
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	health_regen_timer.timeout.connect(on_health_regen_timeout)
	
	GameEvents.health_vial_collected.connect(on_health_vial_collected)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
	MaxLevelEvents.level_up_above_max.connect(on_level_up_above_max)
	
	BoosterEvents.waker_booster_applied.connect(on_waker_booster_applied)
	BoosterEvents.turbo_expresso_booster_applied.connect(on_turbo_expresso_booster_applied)
	
	update_health_display()


func _process(_delta: float):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 or movement_vector.y != 0:
		sprite.play("player_walk")
	else:
		sprite.play("player_idle")

	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)


func update_armor():
	var final_armor_multiplier = upgrade_armor_multiplier * MaxLevelEvents.armor
	var final_armor = base_armor * final_armor_multiplier
	current_armor = final_armor


func update_pickup_area():
	var final_pickup_multiplier = upgrade_pickup_multiplier * MaxLevelEvents.magnet
	var final_pickup_area = base_pickup_radius * final_pickup_multiplier
	pickup_area_collision.shape.radius = final_pickup_area


func update_speed():
	var final_speed_multiplier = upgrade_speed_multiplier * booster_speed_multiplier * MaxLevelEvents.move_speed
	var final_speed = base_speed * final_speed_multiplier
	velocity_component.max_speed = final_speed


func update_total_health():
	var final_health_multiplier = upgrade_health_multiplier * MaxLevelEvents.max_health
	var final_max_health = base_max_health * final_health_multiplier
	var health_ratio = health_component.current_health / health_component.max_health
	health_component.max_health = final_max_health
	health_component.current_health = final_max_health * health_ratio
	update_health_display()


func update_health_regen():
	var final_health_regen_multiplier = upgrade_health_regen_multiplier * MaxLevelEvents.health_regen
	var final_health_regen = base_health_regen * final_health_regen_multiplier
	current_health_regen = final_health_regen


func update_health_display():
	health_bar.value = health_component.get_health_percent()


func play_healing_animation():
	healing_sprite.visible = true
	healing_sprite.play("healing")
	await healing_sprite.animation_finished
	healing_sprite.visible = false


func check_deal_damage(damage: int, damage_source: Node2D):
	if number_colliding_bodies == 0 or not damage_interval_timer.is_stopped():
		return
	
	if "is_frozen" in damage_source and damage_source.is_frozen:
		return
	
	var final_damage = max(1, damage - current_armor)
	
	health_component.damage(final_damage)
	GameEvents.emit_player_damaged()
	SoundUtils.play_player_sound("damage")
	damage_interval_timer.start()


func set_attack_speed_multiplier(multiplier: float):
	attack_speed_multiplier = multiplier


func apply_critical_multiplier() -> float:
	var random_number = randi_range(1, 100)
	
	if random_number <= critical_chance:
		return critical_damage_multiplier
	
	return 1.0


func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	colliding_bodies.append(other_body)
	check_deal_damage(other_body.damage, other_body)


func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1
	colliding_bodies.erase(other_body)


func on_damage_interval_timer_timeout():
	if colliding_bodies.is_empty():
		return

	var strongest_body = colliding_bodies[0]

	for body in colliding_bodies:
		if "is_frozen" in body and body.is_frozen:
			continue
		if body.damage > strongest_body.damage:
			strongest_body = body
	
	check_deal_damage(strongest_body.damage, strongest_body)


func on_health_changed():
	update_health_display()


func on_health_regen_timeout():
	if health_component.current_health == health_component.max_health:
		return
	
	health_component.current_health = min(health_component.current_health + current_health_regen, health_component.max_health)
	update_health_display()


func on_health_vial_collected():
	var health_to_regenerate = 15
	health_component.current_health = min(health_component.max_health, (health_component.current_health + health_to_regenerate))
	update_health_display()
	play_healing_animation()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, _current_upgrades: Dictionary):
	if upgrade == null:
		return
	
	if upgrade is Ability:
		var _ability = upgrade as Ability
		abilities.add_child(upgrade.ability_controller_scene.instantiate())
	elif upgrade.id == "player_speed_main" or upgrade.id == "player_speed":
		upgrade_speed_multiplier += .15
		update_speed()
	elif upgrade.id == "pickup_range_main" or upgrade.id == "pickup_range":
		upgrade_pickup_multiplier += .2
		update_pickup_area()
	elif upgrade.id == "player_health_main" or upgrade.id == "player_health":
		upgrade_health_multiplier += .15
		update_total_health()
	elif upgrade.id == "player_armor_main" or upgrade.id == "player_armor":
		if upgrade.id == "player_armor_main":
			base_armor = 1
		elif upgrade.id == "player_armor":
			upgrade_armor_multiplier += 1
		update_armor()
	elif upgrade.id == "player_regeneration_main" or upgrade.id == "player_regeneration":
		if upgrade.id == "player_regeneration_main":
			base_health_regen = 1
		elif upgrade.id == "player_regeneration":
			upgrade_health_regen_multiplier += .1
		update_health_regen()
	elif upgrade.id == "overall_damage_main" or upgrade.id == "overall_damage":
		overall_damage_multiplier += .15
	elif upgrade.id == "cloner_main" or upgrade.id == "cloner":
		weapon_spawn_amount += 1
	elif upgrade.id == "critical_main" or upgrade.id == "critical":
		critical_chance += 10


func on_level_up_above_max():
	if MaxLevelEvents.random_attribute == "move speed":
		update_speed()
	elif MaxLevelEvents.random_attribute == "armor":
		if base_armor == 0:
			base_armor = 1
		update_armor()
	elif MaxLevelEvents.random_attribute == "max health":
		update_total_health()
	elif MaxLevelEvents.random_attribute == "health regen":
		if base_health_regen == 0:
			base_health_regen = 1
		update_health_regen()
	elif MaxLevelEvents.random_attribute == "magnet":
		update_pickup_area()


func on_waker_booster_applied():
	var health_to_regenerate = health_component.max_health / 2
	health_component.current_health = min(health_component.max_health, (health_component.current_health + health_to_regenerate))
	update_health_display()


func on_turbo_expresso_booster_applied():
	booster_speed_multiplier = 2.0
	update_speed()
	
	await turbo_expresso_booster.timer.timeout
	
	booster_speed_multiplier = 1.0
	update_speed()
